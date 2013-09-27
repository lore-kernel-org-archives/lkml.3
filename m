Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab3I0XoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 19:44:23 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:49271 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab3I0XoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 19:44:21 -0400
MIME-Version: 1.0
In-Reply-To: <1380323960.27811.67.camel@pasglop>
References: <1380270519.27811.10.camel@pasglop>
	<CAE9FiQVkW7d7vFx_kPJG-FEvO71SZjZmpR+dnwVm61wkYK=0YA@mail.gmail.com>
	<CA+55aFyDfMdAeaniQwkoeW6F-xd3JxrzGYwtFb6N9+NA6aRCMg@mail.gmail.com>
	<1380318405.27811.37.camel@pasglop>
	<CAE9FiQXXvkfTak6oEpUog_RYs_Gwpdji7N5UJ=R11Q61==N97A@mail.gmail.com>
	<1380321480.27811.53.camel@pasglop>
	<CAE9FiQWm7ALPO5k_2nV+fuZw4oNNiw+_PEx8EWkb52ymN+EYUg@mail.gmail.com>
	<1380323960.27811.67.camel@pasglop>
Date: Fri, 27 Sep 2013 16:44:20 -0700
X-Google-Sender-Auth: AFkALpLnK7jBRH4GhPiwEG4G3d8
Message-ID: <CAE9FiQV8ipnQ_vV68S-QHMrUrQTWQT_XObxyBeR=dOuw6fG1eg@mail.gmail.com>
Subject: Re: Please revert 928bea964827d7824b548c1f8e06eccbbc4d0d7d
From: Yinghai Lu <yinghai@kernel.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: multipart/mixed; boundary=20cf3010e4dfc06d3304e76610b8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf3010e4dfc06d3304e76610b8
Content-Type: text/plain; charset=ISO-8859-1

[+ Rafael]

On Fri, Sep 27, 2013 at 4:19 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Fri, 2013-09-27 at 15:56 -0700, Yinghai Lu wrote:
>
>> ok, please if you are ok attached one instead. It will print some warning about
>> driver skipping pci_set_master, so we can catch more problem with drivers.
>
> Except that the message is pretty cryptic :-) Especially since the
> driver causing the message to be printed is not the one that did
> the mistake in the first place, it's the next one coming up that
> trips the warning.
>
> In any case, the root cause is indeed the PCIe port driver:
>
> We don't have ACPI, so pcie_port_platform_notify() isn't implemented,
> and pcie_ports_auto is true, so we end up with capabilities set to 0.

in
| commit fe31e69740eddc7316071ed5165fed6703c8cd12
| Author: Rafael J. Wysocki <rjw@sisk.pl>
| Date:   Sun Dec 19 15:57:16 2010 +0100
|
|    PCI/PCIe: Clear Root PME Status bits early during system resume
|
|    I noticed that PCI Express PMEs don't work on my Toshiba Portege R500
|    after the system has been woken up from a sleep state by a PME
|    (through Wake-on-LAN).  After some investigation it turned out that
|    the BIOS didn't clear the Root PME Status bit in the root port that
|    received the wakeup PME and since the Requester ID was also set in
|    the port's Root Status register, any subsequent PMEs didn't trigger
|    interrupts.
|
|    This problem can be avoided by clearing the Root PME Status bits in
|    all PCI Express root ports during early resume.  For this purpose,
|    add an early resume routine to the PCIe port driver and make this
|    driver be always registered, even if pci_ports_disable is set (in
|    which case the driver's only function is to provide the early
|    resume callback).
|
|
|@@ -349,15 +349,18 @@ int pcie_port_device_register(struct pci_dev *dev)
|        int status, capabilities, i, nr_service;
|        int irqs[PCIE_PORT_DEVICE_MAXSERVICES];
|
|-       /* Get and check PCI Express port services */
|-       capabilities = get_port_device_capability(dev);
|-       if (!capabilities)
|-               return -ENODEV;
|-
|        /* Enable PCI Express port device */
|        status = pci_enable_device(dev);
|        if (status)
|                return status;
|+
|+       /* Get and check PCI Express port services */
|+       capabilities = get_port_device_capability(dev);
|+       if (!capabilities) {
|+               pcie_no_aspm();
|+               return 0;
|+       }
|+
|        pci_set_master(dev);
|        /*
|         * Initialize service irqs. Don't use service devices that

>
> Thus the port driver bails out before calling pci_set_master(). The fix
> is to call pci_set_master() unconditionally. However that lead me to
> find to a few interesting oddities in that port driver code:

can we revert that partially change ? aka we should check get_port....
at first...

like attached.

Thanks

Yinghai

--20cf3010e4dfc06d3304e76610b8
Content-Type: application/octet-stream; 
	name="fix_pci_set_master_port_pcie.patch"
Content-Disposition: attachment; 
	filename="fix_pci_set_master_port_pcie.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hm423s9n0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvcGNpL3BjaWUvcG9ydGRydl9jb3JlLmMgYi9kcml2ZXJzL3Bj
aS9wY2llL3BvcnRkcnZfY29yZS5jCmluZGV4IDMxMDYzYWMuLjFlZTZmMTYgMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvcGNpL3BjaWUvcG9ydGRydl9jb3JlLmMKKysrIGIvZHJpdmVycy9wY2kvcGNpZS9w
b3J0ZHJ2X2NvcmUuYwpAQCAtMzYyLDE2ICszNjIsMTYgQEAgaW50IHBjaWVfcG9ydF9kZXZpY2Vf
cmVnaXN0ZXIoc3RydWN0IHBjaV9kZXYgKmRldikKIAlpbnQgc3RhdHVzLCBjYXBhYmlsaXRpZXMs
IGksIG5yX3NlcnZpY2U7CiAJaW50IGlycXNbUENJRV9QT1JUX0RFVklDRV9NQVhTRVJWSUNFU107
CiAKLQkvKiBFbmFibGUgUENJIEV4cHJlc3MgcG9ydCBkZXZpY2UgKi8KLQlzdGF0dXMgPSBwY2lf
ZW5hYmxlX2RldmljZShkZXYpOwotCWlmIChzdGF0dXMpCi0JCXJldHVybiBzdGF0dXM7Ci0KIAkv
KiBHZXQgYW5kIGNoZWNrIFBDSSBFeHByZXNzIHBvcnQgc2VydmljZXMgKi8KIAljYXBhYmlsaXRp
ZXMgPSBnZXRfcG9ydF9kZXZpY2VfY2FwYWJpbGl0eShkZXYpOwogCWlmICghY2FwYWJpbGl0aWVz
KQogCQlyZXR1cm4gMDsKIAorCS8qIEVuYWJsZSBQQ0kgRXhwcmVzcyBwb3J0IGRldmljZSAqLwor
CXN0YXR1cyA9IHBjaV9lbmFibGVfZGV2aWNlKGRldik7CisJaWYgKHN0YXR1cykKKwkJcmV0dXJu
IHN0YXR1czsKKwogCXBjaV9zZXRfbWFzdGVyKGRldik7CiAJLyoKIAkgKiBJbml0aWFsaXplIHNl
cnZpY2UgaXJxcy4gRG9uJ3QgdXNlIHNlcnZpY2UgZGV2aWNlcyB0aGF0Cg==
--20cf3010e4dfc06d3304e76610b8--
