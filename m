Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869Ab3C0LYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 07:24:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:34560 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab3C0LYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 07:24:14 -0400
Date: Wed, 27 Mar 2013 12:24:12 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mike Turquette <mturquette@linaro.org>
cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4] clk: allow reentrant calls into the clk framework
In-Reply-To: <1364368183-24420-1-git-send-email-mturquette@linaro.org>
Message-ID: <alpine.LFD.2.02.1303271209490.22263@ionos>
References: <1364368183-24420-1-git-send-email-mturquette@linaro.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Mar 2013, Mike Turquette wrote:
> +/***  locking & reentrancy ***/
> +
> +static void clk_fwk_lock(void)

This function name sucks as much as the whole implementation does.

> +{
> +	/* hold the framework-wide lock, context == NULL */
> +	mutex_lock(&prepare_lock);
> +
> +	/* set context for any reentrant calls */
> +	atomic_set(&prepare_context, (int) get_current());

And what's the point of the atomic here? There is no need for an
atomic if you hold the lock. Neither here nor on the reader side.

Aside of that, the cast to (int) and the one below to (void *) are
blantantly wrong on 64 bit.

> +}
> +
> +static void clk_fwk_unlock(void)
> +{
> +	/* clear the context */
> +	atomic_set(&prepare_context, 0);
> +
> +	/* release the framework-wide lock, context == NULL */
> +	mutex_unlock(&prepare_lock);
> +}
> +
> +static bool clk_is_reentrant(void)
> +{
> +	if (mutex_is_locked(&prepare_lock))
> +		if ((void *) atomic_read(&prepare_context) == get_current())

Mooo.

> +			return true;
> +
> +	return false;
> +}

Why the heck do you need this function?

Just to sprinkle all these ugly constructs into the code:

> -	mutex_lock(&prepare_lock);
> +	/* re-enter if call is from the same context */
> +	if (clk_is_reentrant()) {
> +		__clk_unprepare(clk);
> +		return;
> +	}

Sigh. Why not doing the obvious?

Step 1/2: Wrap locking in helper functions

+static void clk_prepare_lock(void)
+{
+	mutex_lock(&prepare_lock);
+}
+
+static void clk_prepare_unlock(void)
+{
+	mutex_unlock(&prepare_lock);
+}

That way the whole change in the existing code boils down to:

-	mutex_lock(&prepare_lock);
+	clk_prepare_lock();
...
-	mutex_unlock(&prepare_lock);
+	clk_prepare_unlock();

Ditto for the spinlock.

And there is no pointless reshuffling of functions required.


Step 2/2: Implement reentrancy

+static struct task_struct *prepare_owner;
+static int prepare_refcnt;

static void clk_prepare_lock()
{
-	mutex_lock(&prepare_lock);
+	if (!mutex_trylock(&prepare_lock)) {
+		if (prepare_owner == current) {
+		   	prepare_refcnt++;
+			return;
+		}
+		mutex_lock(&prepare_lock);
+	}
+	WARN_ON_ONCE(prepare_owner != NULL);
+	WARN_ON_ONCE(prepare_refcnt != 0);
+	prepare_owner = current;
+	prepare_refcnt = 1;
}

static void clk_prepare_unlock(void)
{
-	mutex_unlock(&prepare_lock);
+	WARN_ON_ONCE(prepare_owner != current);
+	WARN_ON_ONCE(prepare_refcnt == 0);
+
+	if (--prepare_refcnt)
+		return;
+	prepare_owner = NULL;
+	mutex_unlock(&prepare_lock);
}

Ditto for the spinlock.

That step requires ZERO change to the functions. They simply work and
you don't need all this ugly reentrancy hackery.

Thanks,

	tglx
