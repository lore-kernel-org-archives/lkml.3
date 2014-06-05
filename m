Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644AbaFEKAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 06:00:30 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:24696 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbaFEKA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 06:00:28 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-a9-53903fb9fa61
Message-id: <53903FB8.7060501@samsung.com>
Date: Thu, 05 Jun 2014 12:00:24 +0200
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Wei.Yang@windriver.com, Michal Nazarewicz <mina86@mina86.com>,
        Felipe Balbi <balbi@ti.com>, gregkh@linuxfoundation.org,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] USB:gadget: Fix a warning while loading g_mass_storage
References: <Pine.LNX.4.44L0.1406041100500.922-100000@iolanthe.rowland.org>
In-reply-to: <Pine.LNX.4.44L0.1406041100500.922-100000@iolanthe.rowland.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t/xy7o77ScEG1xdZmBx8H69RfPi9WwW
	l3fNYbNYtKyV2WLB8RZWiwm/L7BZ3H+T4MDusX/uGnaPdX9eMXnMvvuD0eP4je1MHp83yXms
	37KVKYAtissmJTUnsyy1SN8ugSvjwaQXTAWrZSp23c9sYFwi3sXIySEhYCJx+PlsRghbTOLC
	vfVsXYxcHEICSxkl/t3YwAjhfGaUaFj0D6yKV0BLYte0v6wgNouAqsS5c5fA4mwCxhJ7D3aA
	2aICYRIdp14wQ9QLSvyYfI8FxBYB6t3c9JIZZCizwD1GiTUf+tlBEsICfhLrjt4FKxIS8JZY
	/rSXDcTmFPCR+PhrF1icWcBaYuWkbYwQtrzE5jVvmScwCsxCsmMWkrJZSMoWMDKvYhRNLU0u
	KE5KzzXUK07MLS7NS9dLzs/dxAgJ9i87GBcfszrEKMDBqMTD6/C6P1iINbGsuDL3EKMEB7OS
	CK+83YRgId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYxGDefkuJ/oGe2389GY7/KtKndVbFP+5Rec
	MWwZgWUnPJpP3/DWnh82qcjC8VP0nguHdkfeSdzurReQ6Lrepp9P0n1Kkqd89ZzDP03MT0Xc
	F876aCZ/vGHz0tIFDkf/iL9ZOdHj1kmBEzpH3PeK6v3krzIXnLLpya/6rK3vfyl/KhX7baUl
	dVuJpTgj0VCLuag4EQAd3B0/VAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 04.06.2014 17:26, Alan Stern pisze:
> On Wed, 4 Jun 2014, Andrzej Pietrasiewicz wrote:
>

<snip>

> What is the difference in purpose between usb_function and
> usb_function_instance?  I can't tell just by reading the header file.
> Does one of them get created dynamically when the host sets the
> appropriate config?
>

Please see below.
   
<snip>

>>
>> Among traditional gadgets there is no gadget which uses mass storage function
>> more than once. On the other hand, when gadgets are created with configfs
>> it is forbidden to link a given function more than once into a given
>> config,
>
> What is the reason for this restriction?

Please see below.

>
>>   that is a struct usb_function_instance can be referenced by more
>> than one config, but can be referenced only once in a given config;
>> each symbolic link corresponds to an instance of struct usb_function
>> (don't confuse with struct usb_function_instance).
>
> It's extremely easy to confuse them, since I don't understand the
> differences between them.  It even seems like you confused them in this
> description: You mentioned "link a given function", "link corresponds
> to an instance of struct usb_function", and "struct
> usb_function_instance can be referenced by more than one config".
> What's the difference between linking a usb_function and referencing a
> usb_function_instance?  Normally "linking" and "referencing" mean more
> or less the same thing.

As I said, I didn't like the naming here. I got used to it, though,
but understand (and agree) that it is confusing. As far as explaining
the difference is concerned, being a non-native speaker of English
has its influence, too, so let me do it again.

I think it is easier to tell the purpose of the two structures taking
gadgets composed with configfs as example.

In each gadget there is "functions" directory. Function directories
are created there:

$ cd $CONFIGFS_ROOT/usb_gadget/our_gadget
$ mkdir functions/mass_storage.0

mass_storage.0 is internally represented as an instance of
struct usb_function_instance, which has its associated
struct fsg_common (the fsg_common is a member of
container_of(struct usb_function_instance)).

It can be referenced from multiple configurations.

$ ln -s functions/mass_storage.0 configs/config.1
$ ln -s functions/mass_storage.0 configs/config.2

Each reference (symbolic link) is internally represented as
an instance of struct usb_function. The struct usb_function here
has its associated struct fsg_dev (the fsg_dev is a
container_of(struct usb_function)).

By the very nature of any file system one cannot do:

$ ln -s functions/mass_storage.0 configs/config.1
$ ln -s functions/mass_storage.0 configs/config.1 => -EEXIST

By design of how configfs is applied to any usb gadget on cannot even do:

$ ln -s functions/mass_storage.0 configs/config.1/my_mass_storage.0
$ ln -s functions/mass_storage.0 configs/config.1/the_same_mass_storage.0 => -EEXIST

However, there should be no problem with this:

$ mkdir functions/mass_storage.0
$ mkdir functions/mass_storage.1
$ ln -s functions/mass_storage.0 configs/config.1
$ ln -s functions/mass_storage.1 configs/config.1

Legacy gadgets (g_mass_storage, g_acm_ms, g_multi) in fact operate in
a somewhat similar manner, the difference is that instead of creating directories
and making symbolic links, usb_get_function_instance() and usb_get_function()
are called, respectively, and composing a gadget happens from beginning to end
at module init.

I hope this clarifies things a bit.

AP
