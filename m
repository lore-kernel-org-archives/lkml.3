Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab3KKT1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 14:27:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47791 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132Ab3KKT13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 14:27:29 -0500
Message-ID: <52812F92.1020006@zytor.com>
Date: Mon, 11 Nov 2013 11:27:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, tglx@linutronix.de, hpa@linux.intel.com
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/kaslr] x86, kaslr: Provide randomness functions
References: <1381450698-28710-4-git-send-email-keescook@chromium.org> <tip-5bfce5ef55cbe78ee2ee6e97f2e26a8a582008f3@git.kernel.org> <20131111182046.GA14961@gmail.com>
In-Reply-To: <20131111182046.GA14961@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 10:20 AM, Ingo Molnar wrote:
> 
> Why aren't the 3 sources of entropy XOR-ed together?
> 

Note we don't want to poke i8254 if we have any other sources, as the
i8254 may not be present on newer systems and in some other cases not
safe to touch.  We can XOR in the TSC with RDRAND although it seems a
bit odd.

HOWEVER...

+		/* Only use the low bits of rdtsc. */
+		random = raw & 0xffff;

Why?!  All that can do is throw away randomness...

+	/* Extend timer bits poorly... */
+	random |= (random << 16);
+#ifdef CONFIG_X86_64
+	random |= (random << 32);
+#endif

For smearing out bits, a better way is usually to multiply with a large
prime number (preferably a circular multiply.)

> Also, we talked about also adding system dependent entropy sources, such 
> as memory layout or the DMI table - none of that seems to have happened.
> 
> It's not like this function should be performance critical, it's run once 
> per bootup, right? There's just no excuse for not maximizing available 
> entropy in such a situation ...

	-hpa

