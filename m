Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab3LOEK3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 23:10:29 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:39418 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab3LOEK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 23:10:28 -0500
MIME-Version: 1.0
In-Reply-To: <CAMxnaaVEzSuEXRyX5KKKvUJFKTGikP_hfQddT6Ke7Dx6boOuKQ@mail.gmail.com>
References: <CAMxnaaWgUPRb3L2aKpUu62F73GR2iXOfd6LUnTkU0O=Gq-E_sQ@mail.gmail.com>
	<CAE9FiQUtqtBLx3_pdhs=CjgqViGrDL9xdCjLKgs66jA-apHdQA@mail.gmail.com>
	<CAMxnaaVEzSuEXRyX5KKKvUJFKTGikP_hfQddT6Ke7Dx6boOuKQ@mail.gmail.com>
Date: Sat, 14 Dec 2013 20:10:27 -0800
X-Google-Sender-Auth: 7P55c-yl8yNMSzU_goMh90T8PMQ
Message-ID: <CAE9FiQU-77q0CaCEkbH1sbMbnRWKpp3iNRNt-+qgQteOQ_mVhg@mail.gmail.com>
Subject: Re: How to reserve pci bus numbers for hotplug?
From: Yinghai Lu <yinghai@kernel.org>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=485b397dd20b1126b404ed8ae018
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--485b397dd20b1126b404ed8ae018
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Dec 12, 2013 at 11:56 AM, Andreas Noever
<andreas.noever@gmail.com> wrote:
> On Thu, Dec 12, 2013 at 1:21 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Wed, Dec 11, 2013 at 3:37 PM, Andreas Noever
>> <andreas.noever@gmail.com> wrote:
>>
>>> If I could get Linux to assign enough resources (bus numbers for now)
>>> then I could drop the acpi_osi parameter and make thunderbolt work
>>> after suspend... So, is there an easy way to fix this? (Quirks,
>>> reconfiguring bus number assignments from a platform driver, ...?)
>>
>> please check if busn_alloc at
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
>> for-pci-busn-alloc-3.14
>>
>> could help.
>
> It seems to help. The initial assignment looks good:
>            +-01.1-[05-9b]----00.0-[06-27]--+-00.0-[07]----00.0  Intel
> Corporation DSL3510 Thunderbolt Port [Cactus Ridge]
>            |                               +-03.0-[08-0f]--
>            |                               +-04.0-[10-17]--
>            |                               +-05.0-[18-1f]--
>            |                               \-06.0-[20-27]--
> After hotplug it looks like this:
>            +-01.1-[05-9b]----00.0-[06-29]--+-00.0-[07]----00.0  Intel
> Corporation DSL3510 Thunderbolt Port [Cactus Ridge]
>            |
> +-03.0-[08-11]----00.0-[09-11]----00.0-[0a-11]----00.0  Broadcom
> Corporation NetXtreme BCM57762 Gigabit Ethernet PCIe
>            |                               +-04.0-[10-17]--
>            |                               +-05.0-[18-1f]--
>            |                               \-06.0-[20-27]--
> (Note that the bridge numbers are not disjoint)

it should not extend to [08-11] or [06-29]

Please check attached patch that should address bus number wrong extending.
--- missed checking before going up one level ...wrong assumption ...

Thanks

Yinghai

--485b397dd20b1126b404ed8ae018
Content-Type: text/x-patch; charset=US-ASCII; name="fix_probe_resource_assumption.patch"
Content-Disposition: attachment; 
	filename="fix_probe_resource_assumption.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hp7rxszc1

LS0tCiBrZXJuZWwvcmVzb3VyY2UuYyB8ICAgMTAgKysrKysrKystLQogMSBmaWxlIGNoYW5nZWQs
IDggaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCkluZGV4OiBsaW51eC0yLjYva2VybmVs
L3Jlc291cmNlLmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcva2VybmVsL3Jlc291cmNl
LmMKKysrIGxpbnV4LTIuNi9rZXJuZWwvcmVzb3VyY2UuYwpAQCAtMTEzMCw3ICsxMTMwLDkgQEAg
aW50IHByb2JlX3Jlc291cmNlKHN0cnVjdCByZXNvdXJjZSAqYl9yZQogCS8qIFByb2JlIGV4dGVu
ZGVkIHJhbmdlIGFib3ZlIHRvcCAqLwogCW1lbXNldChidXNuX3JlcywgMCwgc2l6ZW9mKHN0cnVj
dCByZXNvdXJjZSkpOwogCXBhcmVudF9yZXMgPSBiX3JlczsKLQl3aGlsZSAocGFyZW50X3JlcyAm
JiAhKHBhcmVudF9yZXMtPmZsYWdzICYgc3RvcF9mbGFncykpIHsKKwl3aGlsZSAoIShwYXJlbnRf
cmVzLT5mbGFncyAmIHN0b3BfZmxhZ3MpKSB7CisJCXN0cnVjdCByZXNvdXJjZSAqdXBfcGFyZW50
X3JlczsKKwogCQlyZXQgPSBfX2FkanVzdF9yZXNvdXJjZShwYXJlbnRfcmVzLCBwYXJlbnRfcmVz
LT5zdGFydCwKIAkJCXJlc291cmNlX3NpemUocGFyZW50X3JlcykgKyAobmVlZGVkX3NpemUgLSBu
X3NpemUpKTsKIAkJaWYgKCFyZXQpIHsKQEAgLTExNTEsNyArMTE1MywxMSBAQCBpbnQgcHJvYmVf
cmVzb3VyY2Uoc3RydWN0IHJlc291cmNlICpiX3JlCiAJCQkvKiByZXQgbXVzdCBiZSAwIGhlcmUq
LwogCQkJZ290byBvdXQ7CiAJCX0KLQkJcGFyZW50X3JlcyA9IHBhcmVudF9yZXMtPnBhcmVudDsK
KwkJLyogYmVmb3JlIGdvIHVwLCBuZWVkIHRvIG1ha2Ugc3VyZSBhdCB0aGUgc2FtZSBlbmQgKi8K
KwkJdXBfcGFyZW50X3JlcyA9IHBhcmVudF9yZXMtPnBhcmVudDsKKwkJaWYgKCF1cF9wYXJlbnRf
cmVzIHx8IHVwX3BhcmVudF9yZXMtPmVuZCAhPSBwYXJlbnRfcmVzLT5lbmQpCisJCQlnb3RvIG91
dDsKKwkJcGFyZW50X3JlcyA9IHVwX3BhcmVudF9yZXM7CiAJfQogCiBvdXQ6Cg==
--485b397dd20b1126b404ed8ae018--
