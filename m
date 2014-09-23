Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbaIWCy1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:54:27 -0400
Received: from mx6-phx2.redhat.com ([209.132.183.39]:46270 "EHLO
	mx6-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbaIWCy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:54:26 -0400
Date: Mon, 22 Sep 2014 22:53:55 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: ltp-list <ltp-list@lists.sourceforge.net>,
        kexec <kexec@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        crash-utility <crash-utility@redhat.com>
Message-ID: <1446076274.27552759.1411440835273.JavaMail.zimbra@redhat.com>
In-Reply-To: <20140922144713.GA4250@redhat.com>
References: <145412866.25258463.1411119061796.JavaMail.zimbra@redhat.com> <293476264.25264480.1411120345360.JavaMail.zimbra@redhat.com> <20140919132236.GB2190@redhat.com> <594480021.25988504.1411355660836.JavaMail.zimbra@redhat.com> <20140922144713.GA4250@redhat.com>
Subject: Re: [RFC] autokdump - automated kdump testsuite
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.7]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - FF17 (Linux)/8.0.6_GA_5922)
Thread-Topic: autokdump - automated kdump testsuite
Thread-Index: da20bpdTGfUWBjQ1Rf1N2ndk3pGCSA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Vivek Goyal" <vgoyal@redhat.com>
> To: "CAI Qian" <caiqian@redhat.com>
> Cc: "ltp-list" sourceforge.net>, "kexec kdump redhat mailing list" <kexec-kdump-list@redhat.com>,
> "kexec" <kexec@lists.infradead.org>, "linux-kernel" vger.kernel.org>, "crash-utility"
> redhat.com>
> Sent: Monday, September 22, 2014 10:47:13 PM
> Subject: Re: [RFC] autokdump - automated kdump testsuite
> 
> On Mon, Sep 22, 2014 at 09:00:00AM -0400, CAI Qian wrote:
> > 
> > 
> > ----- Original Message -----
> > > From: "Vivek Goyal" <vgoyal@redhat.com>
> > > To: "CAI Qian" <caiqian@redhat.com>
> > > Cc: "linux-kernel" vger.kernel.org>, "ltp-list"
> > > sourceforge.net>, "crash-utility"
> > > redhat.com>, "kexec" <kexec@lists.infradead.org>, "kexec
> > > kdump redhat mailing list"
> > > <kexec-kdump-list@redhat.com>
> > > Sent: Friday, September 19, 2014 9:22:36 PM
> > > Subject: Re: [RFC] autokdump - automated kdump testsuite
> > > 
> > > On Fri, Sep 19, 2014 at 05:52:25AM -0400, CAI Qian wrote:
> > > > I plan to release an automated kdump testsuite that will be
> > > 
> > > So will this be a standalone test suit? Can it be merged with
> > > something already existing say, LTP.
> > Yes, it is likely to be standalone. It won't make use of the LTP
> > API, and the LTP kdump test suite is outdated, so there is no
> > benefit to continue working over there.
> 
> So why make it standalone and not replace the old LTP kdump test suite
> with this new one?
It will be totally a rewrite from scratch, and will have no direct relationship
with the rest of the LTP.
> 
> > > 
> > > > focus on testing kernel and the crash utility. It should work
> > > > for all major distros since it will use none of distro-specific
> > > > stuff, and also support different arches including x86, ARM,
> > > > PPC64 and s390x.
> > > > 
> > > > It does the following:
> > > > 1) check if there is a memory reserved for kdump. If not,
> > > >    reserve the memory and reboot the system.
> > > > 2) once the system is back, load kexec on panic and
> > > >    prepare a separate initramfs that including needed
> > > >    modules to load a local filesystem and necessary utilities
> > > 
> > > So you will write logic to prepare custom initramfs or will rely
> > > on dracut or some other utility for that.
> > I'll probably prepare custom initramfs for the sake of simplicity.
> 
> Well, preparing custom initramfs will become very tricky. We used
> to do that and finally we switched to dracut.
> 
> Why not simply let the respective service on the host do this job and
> test only makes sure that kdump service is running. It feels little
> out of place that a test is generating custom initramfs.
Because not every distro will have a kdump service like Fedora.
> 
> > > 
> > > >    in order to analyse /proc/vmcore in the 2nd kernel.
> > > > 3) trigger the system crash using methods like sysrq-c, NMI,
> > > >    and panic_on_hung_task etc.
> > > > 4) in the 2nd kernel, mount a filesystem and use the crash
> > > >    utility to analyse /proc/vmcore. Then, gather the analyse
> > > >    logs, serial console output, dmesg etc into the filesystem.
> > > 
> > > Why not save core and boot back in first kernel and then analyze.
> > > 
> > > Trying to work directly with /proc/vmcore does not test makedumfile
> > > which everybody uses. Also it will require more memory to be reserved
> > > and packing crash and debug vmlinux into initramfs.
> > The additional memory for vmlinux and the crash utility is predictable
> > and manageable, so it can just ask 256M memory reserved before running
> > the program. On the other hand, it is not usually feasible to ask
> > the systems under testing has enough available disk spaces bigger than
> > the memory size.
> 
> makedumpfile will reduce the vmcore file size to few hundreds of mega
> bytes on most of the systems. Especially, this is just a test, so
> system will be lightly loaded and vmcore will be small after filtering.
It probably actually have test cases to heavily loaded the memory before
dumping.
> 
> If there is not enough space, test fails, period. I don't think there
> is any need to try to circumvent that and try to run crash in initramfs.
> And in the process we don't test makedumpfile which is very imporatnt
> component of this whole process.
Test makedumpfile is in plan. Tests failed because of lack of disk space
is a testsuite design problem, and especially problematic on those large
memory systems that we had seen more and more those days.
> 
> IMHO, just rely on "systemctl start kdump" to generate and load custom
> initramfs and save filtered vmcore to root fs by default and alanyze
> vmcore post reboot. That will keep things simple.
Again, not every major distro has that.
   CAI Qian
> 
> Thanks
> Vivek
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
> 
