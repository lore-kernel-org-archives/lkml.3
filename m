Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317AbaFNAVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 20:21:52 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54733 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753222AbaFNAVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 20:21:51 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Kees Cook <keescook@chromium.org>
Cc: Pavel Machek <pavel@ucw.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, Len Brown <len.brown@intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 0/2] make kASLR vs hibernation boot-time selectable
Date: Sat, 14 Jun 2014 02:39:18 +0200
Message-ID: <13135927.OjVm86GPrt@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAGXu5jJSqV2MeuofJP4OEiDytQBqKMgC3cj+tguiwTmpRX1wSQ@mail.gmail.com>
References: <1402602419-27934-1-git-send-email-keescook@chromium.org> <1517175.iyVMqh7r2z@vostro.rjw.lan> <CAGXu5jJSqV2MeuofJP4OEiDytQBqKMgC3cj+tguiwTmpRX1wSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 13, 2014 05:08:21 PM Kees Cook wrote:
> On Fri, Jun 13, 2014 at 5:14 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Friday, June 13, 2014 03:59:57 PM Kees Cook wrote:
> >> On Fri, Jun 13, 2014 at 3:54 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> >> > On Friday, June 13, 2014 03:07:19 PM Kees Cook wrote:
> >
> > [cut]
> >
> >> > I'll have a closer look at that shortly (it's been quite some time since
> >> > I wrote that code).
> >>
> >> Thanks; I'm trying to get a test environment instrumented too so I can
> >> look at this. (At the very least, it sounds like we'll still need my
> >> patch series for other architectures.)
> >
> > How can I obtain a kernel address of the beginning of a given page
> > (as represented by struct page) on x86_64 today?
> 
> I don't know off the top of my head. I've used virt_to_phys, but
> things like PFN_PHYS(page_to_pfn(page)) maybe? I'm not entirely clear
> which you need, but mm.h seems to have the bulk of what I've seen.

OK, I'm not sure how much sense this makes, but at least it should
illustrate the direction. :-)

---
 arch/x86/power/hibernate_64.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-pm/arch/x86/power/hibernate_64.c
===================================================================
--- linux-pm.orig/arch/x86/power/hibernate_64.c
+++ linux-pm/arch/x86/power/hibernate_64.c
@@ -115,7 +115,7 @@ struct restore_data_record {
 	unsigned long magic;
 };
 
-#define RESTORE_MAGIC	0x0123456789ABCDEFUL
+#define RESTORE_MAGIC	0x0123456789ABCDF0UL
 
 /**
  *	arch_hibernation_header_save - populate the architecture specific part
@@ -128,7 +128,8 @@ int arch_hibernation_header_save(void *a
 
 	if (max_size < sizeof(struct restore_data_record))
 		return -EOVERFLOW;
-	rdr->jump_address = restore_jump_address;
+
+	rdr->jump_address = virt_to_phys((void *)restore_jump_address);
 	rdr->cr3 = restore_cr3;
 	rdr->magic = RESTORE_MAGIC;
 	return 0;
@@ -143,7 +144,7 @@ int arch_hibernation_header_restore(void
 {
 	struct restore_data_record *rdr = addr;
 
-	restore_jump_address = rdr->jump_address;
+	restore_jump_address = (unsigned long)phys_to_virt(rdr->jump_address);
 	restore_cr3 = rdr->cr3;
 	return (rdr->magic == RESTORE_MAGIC) ? 0 : -EINVAL;
 }

