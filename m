Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab3JYK6w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 06:58:52 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62070 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752765Ab3JYK6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 06:58:51 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Knut Petersen <Knut_Petersen@t-online.de>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        cpufreq@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [BUG 3.12.rc4] Oops: unable to handle kernel paging request during shutdown
Date: Fri, 25 Oct 2013 13:10:51 +0200
Message-ID: <1529148.xq0P7G6L83@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CA+55aFy3dFGsN_Ckaq8egmaEi_JV_qAVOjR6h3gojyBWwA-jpA@mail.gmail.com>
References: <525BD08C.2080101@t-online.de> <3005031.0yf0g1BPEE@vostro.rjw.lan> <CA+55aFy3dFGsN_Ckaq8egmaEi_JV_qAVOjR6h3gojyBWwA-jpA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 25, 2013 11:07:40 AM Linus Torvalds wrote:
> On Fri, Oct 25, 2013 at 11:10 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Friday, October 25, 2013 11:51:40 AM Rafael J. Wysocki wrote:
> >
> >         /* don't keep reloading if cpufreq_driver exists */
> >         if (cpufreq_get_current_driver())
> > -               return 0;
> > +               return -EEXIST;
> >
> >         if (acpi_disabled)
> > -               return 0;
> > +               return -ENODEV;
> >
> >         pr_debug("acpi_cpufreq_init\n");
> 
> I think:
> 
>  - EBUSY is a better error return than EEXIST here/

My concern about using -EBUSY here was that it might be interpreted as
"try again" by things like udev (which is not what I want to happen).

>   - do the ENODEV case first, because claiming something is busy when
> you couldn't have used it anyway is kind of stupid)

Agreed.

> but yeah, this looks like the right thing. Let's make sure there
> aren't any annoying error messages etc printed out as a result of
> this, though.

Updated patch is appended.

Rafael


---
 drivers/cpufreq/acpi-cpufreq.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-pm/drivers/cpufreq/acpi-cpufreq.c
===================================================================
--- linux-pm.orig/drivers/cpufreq/acpi-cpufreq.c
+++ linux-pm/drivers/cpufreq/acpi-cpufreq.c
@@ -986,12 +986,12 @@ static int __init acpi_cpufreq_init(void
 {
 	int ret;
 
+	if (acpi_disabled)
+		return -ENODEV;
+
 	/* don't keep reloading if cpufreq_driver exists */
 	if (cpufreq_get_current_driver())
-		return 0;
-
-	if (acpi_disabled)
-		return 0;
+		return -EEXIST;
 
 	pr_debug("acpi_cpufreq_init\n");
 

