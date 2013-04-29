Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab3D2PTO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 11:19:14 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:37082 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab3D2PTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 11:19:12 -0400
MIME-Version: 1.0
In-Reply-To: <517E45C8.4060407@cn.fujitsu.com>
References: <1366940841-15370-1-git-send-email-yinghai@kernel.org>
	<CAErSpo5zfHR-agNBdgqfVjCU+-KcTZV+1bvML5Uw-+icDqzzEA@mail.gmail.com>
	<CAE9FiQVEQO-dLJRjn9Z7JgwGWAn1M8S1Tn2_V0Fq+6kB0rG=Bg@mail.gmail.com>
	<CAErSpo7DUDQ_XgVKAfWxqYJA=q85ps46bffV-4a7b0vOzAP5DA@mail.gmail.com>
	<CAE9FiQWv-bN2XzHiQ0WU+Y678zcqs_Owua6vXXijdMO6=0OWpg@mail.gmail.com>
	<517E45C8.4060407@cn.fujitsu.com>
Date: Mon, 29 Apr 2013 08:19:10 -0700
X-Google-Sender-Auth: fYfBcdAlxUWMWJK0uJsH7JFBMPs
Message-ID: <CAE9FiQUXxCH0xjFPk1S7e_JRsBPosqQ=N5Kpcrjp3RNWDh9yZQ@mail.gmail.com>
Subject: Re: [PATCH] PCI: Fix racing for pci device removing via sysfs
From: Yinghai Lu <yinghai@kernel.org>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Content-Type: multipart/mixed; boundary=047d7bd760c4215e4004db81686f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7bd760c4215e4004db81686f
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Apr 29, 2013 at 3:04 AM, Gu Zheng <guz.fnst@cn.fujitsu.com> wrote:
> Hi Yinghai,
>
> On 04/27/2013 05:01 AM, Yinghai Lu wrote:
>
>> On Fri, Apr 26, 2013 at 1:53 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>
>>>
>>> You can't be serious.  This is a disgusting mess.  Checking a list
>>> pointer for LIST_POISON1?  As far as I'm concerned, this is a waste of
>>> my time.

looks like xhci is using that LIST_POISON1 ...

>>
>> Well, then need to hold the bus ref, and check bus->devices list instead.
>
> @@ -341,6 +352,7 @@ remove_store(struct device *dev, struct
>  {
>         int err;
>         unsigned long val;
> +       struct pci_dev *pdev;
>
>         if (strict_strtoul(buf, 0, &val) < 0)
>                 return -EINVAL;
> @@ -351,9 +363,14 @@ remove_store(struct device *dev, struct
>         /* An attribute cannot be unregistered by one of its own methods,
>          * so we have to use this roundabout approach.
>          */
> +       pdev = pci_dev_get(to_pci_dev(dev));
>
> There is no need to increase pci_dev's ref here, because we'll increase it
> in sysfs_schedule_callback.

ok, i missed that. if we can use LIST_POISON, then could be more simple.

like -v4.

>
> +       get_device(&pdev->bus->dev);
>
> So the pci_bus' ref management is still needed.

No, we don't need that as first pci_stop_and_remove_bus_device()
already drop that reference.

Yinghai

--047d7bd760c4215e4004db81686f
Content-Type: application/octet-stream; name="fix_racing_removing_4.patch"
Content-Disposition: attachment; filename="fix_racing_removing_4.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hg3slki80

U3ViamVjdDogW1BBVENIIC12NF0gUENJOiBGaXggcmFjaW5nIGZvciBwY2kgZGV2aWNlIHJlbW92
aW5nIHZpYSBzeXNmcwpGcm9tOiBZaW5naGFpIEx1IDx5aW5naGFpQGtlcm5lbC5vcmc+CgpHdSBm
b3VuZCBuZXN0ZWQgcmVtb3ZpbmcgdGhyb3VnaAoJZWNobyAtbiAxID4gL3N5cy9idXMvcGNpL2Rl
dmljZXMvMDAwMFw6MTBcOjAwLjAvcmVtb3ZlIDsgZWNobyAtbiAxID4KL3N5cy9idXMvcGNpL2Rl
dmljZXMvMDAwMFw6MWFcOjAxLjAvcmVtb3ZlCgp3aWxsIGNhdXNlIGtlcm5lbCBjcmFzaCBhcyBi
dXMgZ2V0IGZyZWVkLgoKWyAgNDE4Ljk0NjQ2Ml0gQ1BVIDQKWyAgNDE4Ljk2ODM3N10gUGlkOiA1
MTIsIGNvbW06IGt3b3JrZXIvdToyIFRhaW50ZWQ6IEcgICAgICAgIFcgICAgMy44LjAgIzIKRlVK
SVRTVS1TViBQUklNRVFVRVNUIDE4MDBFL1NCClsgIDQxOS4wODE3NjNdIFJJUDogMDAxMDpbPGZm
ZmZmZmZmODEzNzk3MmU+XSAgWzxmZmZmZmZmZjgxMzc5NzJlPl0KcGNpX2J1c19yZWFkX2NvbmZp
Z193b3JkKzB4NWUvMHg5MApbICA0MjAuNDk0MTM3XSBDYWxsIFRyYWNlOgpbICA0MjAuNTIzMzI2
XSAgWzxmZmZmZmZmZjgxMzg1MWVmPl0gPyByZW1vdmVfY2FsbGJhY2srMHgxZi8weDQwClsgIDQy
MC41OTE5ODRdICBbPGZmZmZmZmZmODEzODA0NGI+XSBwY2lfcG1lX2FjdGl2ZSsweDRiLzB4MWMw
ClsgIDQyMC42NTg1NDVdICBbPGZmZmZmZmZmODEzN2Q4ZTc+XSBwY2lfc3RvcF9idXNfZGV2aWNl
KzB4NTcvMHhiMApbICA0MjAuNzI5MjU5XSAgWzxmZmZmZmZmZjgxMzdkYWI2Pl0gcGNpX3N0b3Bf
YW5kX3JlbW92ZV9idXNfZGV2aWNlKzB4MTYvMHgzMApbICA0MjAuODExMzkyXSAgWzxmZmZmZmZm
ZjgxMzg1MWZiPl0gcmVtb3ZlX2NhbGxiYWNrKzB4MmIvMHg0MApbICA0MjAuODc3OTU1XSAgWzxm
ZmZmZmZmZjgxMjU3YTU2Pl0gc3lzZnNfc2NoZWR1bGVfY2FsbGJhY2tfd29yaysweDI2LzB4NzAK
Cmh0dHBzOi8vYnVnemlsbGEua2VybmVsLm9yZy9zaG93X2J1Zy5jZ2k/aWQ9NTQ0MTEKCldlIGhh
dmUgb25lIHBhdGNoIHRoYXQgd2lsbCBsZXQgZGV2aWNlIGhvbGQgYnVzIHJlZiB0byBwcmV2ZW50
IGl0IGZyb20KYmVpbmcgZnJlZWQsIGJ1dCB0aGF0IHdpbGwgc3RpbGwgZ2VuZXJhdGUgd2Fybmlu
Zy4KCi0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpXQVJOSU5HOiBhdCBsaWIv
bGlzdF9kZWJ1Zy5jOjUzIF9fbGlzdF9kZWxfZW50cnkrMHg2My8weGQwKCkKSGFyZHdhcmUgbmFt
ZTogUFJJTUVRVUVTVCAxODAwRQpsaXN0X2RlbCBjb3JydXB0aW9uLCBmZmZmODgwN2QxYjZjMDAw
LT5uZXh0IGlzIExJU1RfUE9JU09OMSAoZGVhZDAwMDAwMDEwMDEwMCkKQ2FsbCBUcmFjZToKIFs8
ZmZmZmZmZmY4MTA1NmQ0Zj5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4N2YvMHhjMAogWzxmZmZm
ZmZmZjgxMDU2ZTQ2Pl0gd2Fybl9zbG93cGF0aF9mbXQrMHg0Ni8weDUwCiBbPGZmZmZmZmZmODEy
ODBiMTM+XSBfX2xpc3RfZGVsX2VudHJ5KzB4NjMvMHhkMAogWzxmZmZmZmZmZjgxMjgwYjkxPl0g
bGlzdF9kZWwrMHgxMS8weDQwCiBbPGZmZmZmZmZmODEyOTgzMzE+XSBwY2lfZGVzdHJveV9kZXYr
MHgzMS8weGMwCiBbPGZmZmZmZmZmODEyOTg1YmI+XSBwY2lfcmVtb3ZlX2J1c19kZXZpY2UrMHg1
Yi8weDcwCiBbPGZmZmZmZmZmODEyOTg1ZWU+XSBwY2lfc3RvcF9hbmRfcmVtb3ZlX2J1c19kZXZp
Y2UrMHgxZS8weDMwCiBbPGZmZmZmZmZmODEyOWZjODk+XSByZW1vdmVfY2FsbGJhY2srMHgyOS8w
eDQwCiBbPGZmZmZmZmZmODExZjNiODQ+XSBzeXNmc19zY2hlZHVsZV9jYWxsYmFja193b3JrKzB4
MjQvMHg3MAoKV2UgY2FuIGp1c3QgY2hlY2sgaWYgdGhlIGRldmljZSBnZXQgcmVtb3ZlZCBmcm9t
IHBjaSB0cmVlCmFscmVhZHkgaW4gdGhlIHByb3RlY3Rpb24gdW5kZXIgcGNpX3JlbW92ZV9yZXNj
YW5fbXV0ZXguCgotdjI6IGNoZWNrIGlmIHRoZSBkZXYtPmJ1c19saXN0IGlzIHBvaXNvbmVkIGlu
c3RlYWQgdG8KICAgICBmaW5kIG91dCBpZiBpdCBpcyByZW1vdmVkIGFscmVhZHkuCiAgICAgQWxz
byBhZGQgb25lIGV4dHJhIHJlZiB0byBkZXYgdG8gbWFrZSBzdXJlIGRldiBpcyBub3QKICAgICBn
ZXQgZnJlZWQgdG9vIGVhcmx5LgotdjQ6IHJlbW92ZSBub3QgbmVlZGVkIHJlZiBob2xkaW5nIHBv
aW50ZWQgYnkgR3UgWmhlbmcuCgpSZXBvcnRlZC1ieTogR3UgWmhlbmcgPGd1ei5mbnN0QGNuLmZ1
aml0c3UuY29tPgpUZXN0ZWQtYnk6IEd1IFpoZW5nIDxndXouZm5zdEBjbi5mdWppdHN1LmNvbT4K
U2lnbmVkLW9mZi1ieTogWWluZ2hhaSBMdSA8eWluZ2hhaUBrZXJuZWwub3JnPgoKLS0tCiBkcml2
ZXJzL3BjaS9wY2ktc3lzZnMuYyB8ICAgIDMgKystCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRp
b25zKCspLCAxIGRlbGV0aW9uKC0pCgpJbmRleDogbGludXgtMi42L2RyaXZlcnMvcGNpL3BjaS1z
eXNmcy5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2RyaXZlcnMvcGNpL3BjaS1zeXNm
cy5jCisrKyBsaW51eC0yLjYvZHJpdmVycy9wY2kvcGNpLXN5c2ZzLmMKQEAgLTMzMSw3ICszMzEs
OCBAQCBzdGF0aWMgdm9pZCByZW1vdmVfY2FsbGJhY2soc3RydWN0IGRldmljCiAJc3RydWN0IHBj
aV9kZXYgKnBkZXYgPSB0b19wY2lfZGV2KGRldik7CiAKIAltdXRleF9sb2NrKCZwY2lfcmVtb3Zl
X3Jlc2Nhbl9tdXRleCk7Ci0JcGNpX3N0b3BfYW5kX3JlbW92ZV9idXNfZGV2aWNlKHBkZXYpOwor
CWlmIChwZGV2LT5idXNfbGlzdC5uZXh0ICE9IExJU1RfUE9JU09OMSkKKwkJcGNpX3N0b3BfYW5k
X3JlbW92ZV9idXNfZGV2aWNlKHBkZXYpOwogCW11dGV4X3VubG9jaygmcGNpX3JlbW92ZV9yZXNj
YW5fbXV0ZXgpOwogfQogCg==
--047d7bd760c4215e4004db81686f--
