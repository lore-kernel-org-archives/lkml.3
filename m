Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbaG2WDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 18:03:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59258 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbaG2WDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 18:03:16 -0400
Date: Tue, 29 Jul 2014 15:03:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chintan Pandya <cpandya@codeaurora.org>
Cc: tglx@linutronix.de, john.stultz@linaro.org, peterz@infradead.org,
        mingo@redhat.com, hughd@google.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2 2/2] ksm: Provide support to use deferrable timers
 for scanner thread
Message-Id: <20140729150314.ceacf0c36459196d2f088575@linux-foundation.org>
In-Reply-To: <1406299698-6357-2-git-send-email-cpandya@codeaurora.org>
References: <1406299698-6357-1-git-send-email-cpandya@codeaurora.org>
	<1406299698-6357-2-git-send-email-cpandya@codeaurora.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2014 20:18:18 +0530 Chintan Pandya <cpandya@codeaurora.org> wrote:

> KSM thread to scan pages is scheduled on definite timeout. That wakes
> up CPU from idle state and hence may affect the power consumption.
> Provide an optional support to use deferrable timer which suites
> low-power use-cases.
> 
> Typically, on our setup we observed, 10% less power consumption with
> some use-cases in which CPU goes to power collapse frequently. For
> example, playing audio while typically CPU remains idle.
> 
> To enable deferrable timers,
> $ echo 1 > /sys/kernel/mm/ksm/deferrable_timer
> 
> ...
>
> --- a/Documentation/vm/ksm.txt
> +++ b/Documentation/vm/ksm.txt
> @@ -87,6 +87,13 @@ pages_sharing    - how many more sites are sharing them i.e. how much saved
>  pages_unshared   - how many pages unique but repeatedly checked for merging
>  pages_volatile   - how many pages changing too fast to be placed in a tree
>  full_scans       - how many times all mergeable areas have been scanned
> +deferrable_timer - whether to use deferrable timers or not
> +                 e.g. "echo 1 > /sys/kernel/mm/ksm/deferrable_timer"
> +                 Default: 0 (means, we are not using deferrable timers. Users
> +		 might want to set deferrable_timer option if they donot want
> +		 ksm thread to wakeup CPU to carryout ksm activities thus
> +		 gaining on battery while compromising slightly on memory
> +		 that could have been saved.)

Text indenting is odd.

> 
> ...
>  
> +static ssize_t deferrable_timer_store(struct kobject *kobj,
> +				     struct kobj_attribute *attr,
> +				     const char *buf, size_t count)
> +{
> +	unsigned long enable;
> +	int err;
> +
> +	err = kstrtoul(buf, 10, &enable);

Unhandled error.

> +	if (enable == 0 || enable == 1)
> +		use_deferrable_timer = enable;
> +
> +	return count;

Should return -EINVAL if `enable' is invalid.


--- a/Documentation/vm/ksm.txt~ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix
+++ a/Documentation/vm/ksm.txt
@@ -88,12 +88,12 @@ pages_unshared   - how many pages unique
 pages_volatile   - how many pages changing too fast to be placed in a tree
 full_scans       - how many times all mergeable areas have been scanned
 deferrable_timer - whether to use deferrable timers or not
-                 e.g. "echo 1 > /sys/kernel/mm/ksm/deferrable_timer"
-                 Default: 0 (means, we are not using deferrable timers. Users
-		 might want to set deferrable_timer option if they donot want
-		 ksm thread to wakeup CPU to carryout ksm activities thus
-		 gaining on battery while compromising slightly on memory
-		 that could have been saved.)
+                   e.g. "echo 1 > /sys/kernel/mm/ksm/deferrable_timer"
+                   Default: 0 (means, we are not using deferrable timers. Users
+		   might want to set deferrable_timer option if they donot want
+		   ksm thread to wakeup CPU to carryout ksm activities thus
+		   gaining on battery while compromising slightly on memory
+		   that could have been saved.)
 
 A high ratio of pages_sharing to pages_shared indicates good sharing, but
 a high ratio of pages_unshared to pages_sharing indicates wasted effort.
--- a/mm/ksm.c~ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix
+++ a/mm/ksm.c
@@ -2202,10 +2202,11 @@ static ssize_t deferrable_timer_store(st
 	int err;
 
 	err = kstrtoul(buf, 10, &enable);
-
-	if (enable == 0 || enable == 1)
-		use_deferrable_timer = enable;
-
+	if (err < 0)
+		return err;
+	if (enable >= 1)
+		return -EINVAL;
+	use_deferrable_timer = enable;
 	return count;
 }
 KSM_ATTR(deferrable_timer);
_

