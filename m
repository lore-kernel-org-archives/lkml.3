Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab3HFJVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 05:21:06 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45699 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab3HFJVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 05:21:04 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <5200BFB3.2050202@jp.fujitsu.com>
Date: Tue, 06 Aug 2013 18:19:47 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>
CC: Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Fenghua Yu <fenghua.yu@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        bhelgaas@google.com, jingbai.ma@hp.com
Subject: [Help Test] kdump, x86, acpi: Reproduce CPU0 SMI corruption issue
 after unsetting BSP flag
Content-Type: multipart/mixed;
 boundary="------------030509050002070401040205"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030509050002070401040205
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hello,

I've addressing kdump restriction that there's only one cpu available
on the kdump 2nd kernel. Now I need to check if the following CPU0 SMI
corruption issue fixed in the following commit can again be reproduced
by unsetting BSP flag of the boot cpu:

commit 74b5820808215f65b70b05a099d6d3c969b82689
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Wed Jul 29 15:54:25 2009 -0600

    ACPI: bind workqueues to CPU 0 to avoid SMI corruption

    On some machines, a software-initiated SMI causes corruption unless the
    SMI runs on CPU 0.  An SMI can be initiated by any AML, but typically it's
    done in GPE-related methods that are run via workqueues, so we can avoid
    the known corruption cases by binding the workqueues to CPU 0.

    References:
        http://bugzilla.kernel.org/show_bug.cgi?id=13751
        https://bugs.launchpad.net/bugs/157171
        https://bugs.launchpad.net/bugs/157691

    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

The reason is that in the current situation, I have two ideas to deal
with the avove kdump restriction:

  1) Disable BSP at the 2nd kernel, posted at:
    [PATCH v1 0/2] x86, apic: Disable BSP if boot cpu is AP
    https://lkml.org/lkml/2012/10/16/15

  2) Unset BSP flag at the 1st kernel, suggested by Eric Biederman
     during the discussion of the idea 1).

On the idea 1), BSP is disabled on the kdump 2nd kernel. My conclusion
is that we have no method to reset BSP, i.e. recover BPS's healthy
state, while we can recover AP by means of INIT as described in MP
specification.

The idea 2) is simpler. We unset BSP flag of the boot cpu at 1st
kernel. The behaviour when receiving INIT depends on whether or not
BSP flag is set or not on its MSR; we can set and unset BSP flag of
MSR freely at runtime. (I don't mean we should).

So, next thing I should do is to evalute risk of the idea 2). In fact,
during the discussion of the idea 1), HPA pointed out that some kind
of firmware affects if BSP flag is unset. Also, maybe from the same
reason, recently introduced cpu0 hot-plugging feature by Fenghua Yu
doesn't appear to unset BSP flag.

The biggest problem next is that I don't have any machines reported in
the bugzilla articles; this issue inherently depends on firmware.

So, could anyone help testing the idea 2) above if you have which of
the following machines? (or other ones that can lead to the same bug)

- HP Compaq 6910p
- HP Compaq 6710b
- HP Compaq 6710s
- HP Compaq 6510b
- HP Compaq 2510p

I prepared a small programs for this test. See the attached file.
The steps to try to reproduce the bug is as follows:

  1. $ tar xf bsp_flag_modules.tar.gz; cd bsp_flag_modules
  2. $ make # to build these programs
  3. $ insmod unsetbspflag.ko # to unset BSP flag of the boot cpu
  4. $ insmod getcpuinfo.ko # to confirm if BSP flag of the boot cpu has
                            # been unset.
     $ dmesg | tail
  5. Close the lid of the machine.
  6. Wait some minutes if necessary.
  7. Open the lid and you can see oops on the screen if bug has
    successfully been reproduced.

-- 
Thanks.
HATAYAMA, Daisuke

--------------030509050002070401040205
Content-Type: application/gzip;
 name="bsp_flag_modules.tar.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="bsp_flag_modules.tar.gz"

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
AA==
--------------030509050002070401040205--

