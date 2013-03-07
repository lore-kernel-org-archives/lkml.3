Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759801Ab3CGUVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 15:21:36 -0500
Received: from mail.windriver.com ([147.11.1.11]:42860 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab3CGUVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 15:21:34 -0500
Message-ID: <5138F68A.6070203@windriver.com>
Date: Thu, 7 Mar 2013 15:20:26 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mike Frysinger <vapier@gentoo.org>, Ingo Molnar <mingo@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Michal Simek <monstr@monstr.eu>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH v2] early_printk: consolidate random copies of identical
 code
References: <1362683754-706-1-git-send-email-paul.gortmaker@windriver.com> <20130307112536.82288f41924a38a441cdf345@linux-foundation.org>
In-Reply-To: <20130307112536.82288f41924a38a441cdf345@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-03-07 02:25 PM, Andrew Morton wrote:
> On Thu, 7 Mar 2013 14:15:54 -0500 Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
> 
>> [v2: essentially unchanged since v1, so I've left the acked/reviewed
>>  tags.  There was a compile fail[1] for a randconfig with EARLY_PRINTK=y
>>  and PRINTK=n, because the early_console struct and early_printk calls
>>  were nested within an #ifdef CONFIG_PRINTK -- moving that whole block
>>  exactly as-is to be outside the #ifdef CONFIG_PRINTK fixes the randconfig
>>  and still works for everyday sane configs too.]
>>  [1] http://marc.info/?l=linux-next&m=136219350914998&w=2   
> 
> You did this:
> 

[...]

> _
> 
> Problem is, that won't fix the various compilation problems we've had. 
> See yesterday's lkml thread "linux-next: build failure after merge of
> the final tree (akpm tree related)"

Unless I'm missing something, the easy fix for that is to just
unconditionally have an early_console, i.e. this one line change
on top of the v2 patch:

diff --git a/kernel/printk.c b/kernel/printk.c
index 7664e49..86799bf 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -120,6 +120,7 @@ struct console_cmdline
 static struct console_cmdline console_cmdline[MAX_CMDLINECONSOLES];
 static int selected_console = -1;
 static int preferred_console = -1;
+struct console *early_console;
 int console_set_on_cmdline;
 EXPORT_SYMBOL(console_set_on_cmdline);
 
@@ -1718,7 +1719,6 @@ static size_t cont_print_text(char *text, size_t size) { return 0; }
 #endif /* CONFIG_PRINTK */
 
 #ifdef CONFIG_EARLY_PRINTK
-struct console *early_console;
 
 void early_vprintk(const char *fmt, va_list ap)
 {


Then you don't have to spray any of those ifdefs into the sparc code.
I've build tested the above tweak for sparc32/64 defconfig.  Also built
for powerpc (sbc8548) -- note that you can't turn off EARLY_PRINTK
for ppc as it is:

config EARLY_PRINTK
        bool
        default y

i.e. no help text and no prompting. And the kooky randconfig and a
sane x86 defconfig are still OK too.  Unless you see something else
that I'm overlooking, I can send a v3 that incorporates the above
small tweak.

Thanks,
Paul.
