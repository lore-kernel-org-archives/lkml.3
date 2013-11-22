Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab3KVVzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 16:55:40 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64114 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932112Ab3KVVzj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 16:55:39 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Francis Moreau <francis.moro@gmail.com>
Cc: Jingoo Han <jg1.han@samsung.com>, "'Borislav Petkov'" <bp@alien8.de>,
        "'Wei WANG'" <wei_wang@realsil.com.cn>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Thomas Gleixner'" <tglx@linutronix.de>,
        "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Chris Ball'" <cjb@laptop.org>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
Date: Fri, 22 Nov 2013 23:08:20 +0100
Message-ID: <2363041.q8n2SXViVK@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <528FCE57.2000805@gmail.com>
References: <20131117195358.GO27323@pd.tnic> <24318767.PoCLxGCZH4@vostro.rjw.lan> <528FCE57.2000805@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 22, 2013 10:36:23 PM Francis Moreau wrote:
> On 11/22/2013 01:54 PM, Rafael J. Wysocki wrote:
> > On Friday, November 22, 2013 10:57:25 AM Francis Moreau wrote:
> >> Le 22/11/2013 08:43, Francis Moreau a écrit :
> >>> Le 21/11/2013 12:17, Jingoo Han a écrit :
> >>> [...]
> >>>>>
> >>>>>> Also I took a look at the changes between v3.11 and v3.12 in this area
> >>>>>> and those changes match the issue I'm facing:
> >>>>>>
> >>>>>> $ git log --oneline v3.11..v3.12 -- drivers/mfd/rtsx_pcr.c
> >>>>>> 09fd867 mfd: rtsx: Copyright modifications
> >>>>>> eb891c6 mfd: rtsx: Configure to enter a deeper power-saving mode in S3
> >>>>>> 7140812 mfd: rtsx: Move some actions from rtsx_pci_init_hw to individual
> >>>>>> extra_init_hw
> >>>>>> 5947c16 mfd: rtsx: Add shutdown callback in rtsx_pci_driver
> >>>>>> 773ccdf mfd: rtsx: Read vendor setting from config space
> >>>>
> >>>> In my opinion, rtsx_pci_resume()/rtsx_pci_suspend() in realtek PCIe card
> >>>> reader driver may make the kernel panic.
> >>>>
> >>>> I think that the commit "mfd: rtsx: Configure to enter a deeper
> >>>> power-saving mode in S3" may be the culprit.
> >>>
> >>> Unfortunately no, reverting this commit on top of v3.12 doesn't help. I
> >>> also reverted 7140812, 5947c16 but it didn't improve anything.
> >>>
> >>> The good news is that I managed to have a "light" kernel configuration
> >>> which is faster to build and more important it seems that the bug is
> >>> almost 100% reproductible now.
> >>>
> >>> So I'll try to do another git-bisect session later.
> >>
> >> So after bisecting between v3.11..v3.12 range, git bisect told me:
> >>
> >> the first bad commit is 551f5c74e17ba9257cdc35bf657ee448cad2d5b0
> >>
> >> Merge branch 'acpi-processor'
> >>
> >>     * acpi-processor:
> >>       ACPI / processor: Acquire writer lock to update CPU maps
> >>       ACPI / processor: Remove acpi_processor_get_limit_info()
> >>
> >> The two commits brought by the merge are not the culprits because
> >> reseting HEAD on "ACPI / processor: Acquire writer lock to update CPU
> >> maps" doesn't have the issue anymore.
> >>
> >> At that point I'm not sure how to bisect futher.
> > 
> > Does the second parent of this merge (that is, 8462d9df9d50) have the problem?
> > 
> 
> Yes it does.
> 
> Ok, I've finally managed to find out the bad commit:
> ad07277e82dedabacc52c82746633680a3187d25: ACPI / PM: Hold acpi_scan_lock
> over system PM transitions
> 
> I verified that the parent commit doesn't have the problem.

Interesting.

> Rafael, you're the man now ;)

I kind of don't see how that commit may result in behavior that you
described earlier in the thread.

You get a memory corruption that seems to have started to happen because
we're holding an additional lock over suspend resume now.  Something's fishy
on that machine and we need to figure out what it is.

Please file a bug at bugzilla.kernel.org against ACPI and assign it to me.
Please put all of the relevant info in there and attach the output of dmesg
after a fresh boot and the output of acpidump from the affected machine to
the bug entry.

Thanks,
Rafael

