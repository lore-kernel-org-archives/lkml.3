Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbaH1XBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 19:01:54 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:46776 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaH1XBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 19:01:53 -0400
X-Greylist: delayed 1186 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Aug 2014 19:01:53 EDT
X-Cam-AntiVirus: no malware found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <53FFB045.9010809@citrix.com>
Date: Thu, 28 Aug 2014 23:42:13 +0100
From: Andrew Cooper <andrew.cooper3@citrix.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Stefan Bader <stefan.bader@canonical.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Kees Cook <keescook@chromium.org>,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [Xen-devel] [PATCH] Solved the Xen PV/KASLR riddle
References: <20140827204940.GA10556@laptop.dumpdata.com> <1409248903-19625-1-git-send-email-stefan.bader@canonical.com>
In-Reply-To: <1409248903-19625-1-git-send-email-stefan.bader@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/08/2014 19:01, Stefan Bader wrote:
>>> So not much further... but then I think I know what I do next. Probably should
>>> have done before. I'll replace the WARN_ON in vmalloc that triggers by a panic
>>> and at least get a crash dump of that situation when it occurs. Then I can dig
>>> in there with crash (really should have thought of that before)...
>> <nods> I dug a bit in the code (arch/x86/xen/mmu.c) but there is nothing there
>> that screams at me, so I fear I will have to wait until you get the crash
>> and get some clues from that.
> Ok, what a journey. So after long hours of painful staring at the code...
> (and btw, if someone could tell me how the heck one can do a mfn_to_pfn
> in crash, I really would appreaciate :-P)

The M2P map lives in the Xen reserved virtual address space in each PV
guest, and forms part of the PV ABI.  It is mapped read-only, in the
native width of the guest.

32bit PV (PAE) at 0xF5800000
64bit PV at 0xFFFF800000000000

This is represented by the MACH2PHYS_VIRT_START symbol from the Xen
public header files.  You should be able to blindly construct a pointer
to it (if you have nothing better to hand), as it will be hooked into
the guests pagetables before execution starts.  Therefore,
"MACH2PHYS_VIRT_START[(unsigned long)pfn]" ought to do in a pinch.

~Andrew
