Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933666AbaFJUjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:39:08 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:35492 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932880AbaFJUjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 16:39:04 -0400
MIME-Version: 1.0
In-Reply-To: <20140610122008.GA31944@hansolo.jdub.homelinux.org>
References: <1402331614.7064.60.camel@dhcp-9-2-203-236.watson.ibm.com>
	<cover.1402387862.git.d.kasatkin@samsung.com>
	<20140610122008.GA31944@hansolo.jdub.homelinux.org>
Date: Tue, 10 Jun 2014 23:39:03 +0300
Message-ID: <CACE9dm9CN+FdhhWeur_WSi+0i_Sj=tFJjU6YgM4_B-5oTLTuLQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] KEYS: validate key trust with owner and builtin keys only
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, keyrings <keyrings@linux-nfs.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 June 2014 15:20, Josh Boyer <jwboyer@redhat.com> wrote:
> On Tue, Jun 10, 2014 at 11:48:14AM +0300, Dmitry Kasatkin wrote:
>> Hi Mimi,
>>
>> As you asked ofline , here is possible equivalent and simpler alternative
>> patches not requiring to have additional keyring.
>>
>> First patch are irrelevant minor fixes.
>>
>> Also I want to discuss here Fedora UEFI patches as they are the reason for
>> the these original patchset.
>>
>> http://pkgs.fedoraproject.org/cgit/kernel.git/tree/modsign-uefi.patch
>>
>> They provide functionality to specify MokIgnoreDb variable to limit loading of
>> UEFI keys only from MOK List, while ignoring DB. This is certainly a good
>> functionality. But once MODULE_SIG_UEFI is enabled, it looks there is no way
>> to prevent loading keys from UEFI at all. And this might not be a good default
>> functionality. Someone might want not allow loading of keys from UEFI unless
>> kernel parameter is specified to allow it without recompiling the kernel
>> and disabling MODULE_SIG_UEFI.
>>
>> Josh, why such design decision was made?
>
> IIRC, it's because kernel parameters can be added programmatically from a
> remote user if they gain root access.  Having a kernel parameter to
> disable a key piece of secure boot isn't all that great.  We disable
> other kernel parameters like acpi_rspd as well.
>

(repost in plain text)

It just was in my mind. And Mathew uncovered it.

Parameter does not disable security....

Preventing loading keys from uefi except dbx by default actually
improves security.
Adding kernel parameter to read db we make system more vulnerable.

So default should be to read dbx but not db.
Based on kernel parameter to read also db.

- Dmitry

>> Why not to provide kernel parameter to have more fine-tune control over the
>> functionality? Unconfigured machines will not have MokIgnoreDb and will
>> allow to load kernel modules signed with certain undesired keys. In fact,
>
> Undesired by whom?  If SB is enabled, your machine's firmware already
> trusts those keys.
>
>> I beleive, it should be default behavior of the kernel. Bootloader can
>> enable UEFI functionality by specifing it on the kernel command line.
>
> If it was enabled via boot params, or done in the early setup code that
> might be possible.  I don't think a kernel parameter is the right
> solution though.  I've added Matthew on CC.
>
> josh
>
>> Second patch allows to overcome keys coming from UEFI for key validation by
>> specifing owner key id and is an alternative for v5 4/4 patch.
>>
>> It was also a good idea presented in Mimi's v4 4/4 patch to have possibility
>> to limit key trust valiation by only builtin keys. Third patch as an alternative.
>> It uses keys->flags to specify origin of the key, but any additional field could
>> be added as well.
>>
>> Both key id and origin verification is done in x509_validate_trust().
>>
>> Thanks,
>> Dmitry
>>
>> Dmitry Kasatkin (3):
>>   KEYS: fix couple of things
>>   KEYS: validate key trust only with selected owner key
>>   KEYS: validate key trust only with builtin keys
>>
>> Mimi Zohar (1):
>>   KEYS: define an owner trusted keyring
>>
>>  Documentation/kernel-parameters.txt      |  5 +++++
>>  crypto/asymmetric_keys/x509_public_key.c | 35 +++++++++++++++++++++++++++++---
>>  include/linux/key.h                      |  1 +
>>  kernel/system_keyring.c                  |  1 +
>>  4 files changed, 39 insertions(+), 3 deletions(-)
>>
>> --
>> 1.9.1
>>



-- 
Thanks,
Dmitry
