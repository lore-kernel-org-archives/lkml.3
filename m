Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbaA1C2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 21:28:32 -0500
Received: from ozlabs.org ([203.10.76.45]:54309 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbaA1C2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 21:28:23 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tom Gundersen <teg@jklm.no>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org, kay@vrfy.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [RFC][PATCH] module: allow multiple calls to MODULE_DEVICE_TABLE() per module
In-Reply-To: <20140127195422.GB21018@kroah.com>
References: <1390849795-2155-1-git-send-email-teg@jklm.no> <20140127195422.GB21018@kroah.com>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Tue, 28 Jan 2014 12:04:53 +1030
Message-ID: <87mwigzy6a.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> On Mon, Jan 27, 2014 at 08:09:55PM +0100, Tom Gundersen wrote:
>> Commit 78551277e4df5: "Input: i8042 - add PNP modaliases" had a bug, where the
>> second call to MODULE_DEVICE_TABLE() overrode the first resulting in not all
>> the modaliases being exposed.
>> 
>> This fixes the problem by including the name of the device_id table in the
>> __mod_*_device_table alias, allowing us to export several device_id tables
>> per module.
>> 
>> Suggested-by: Kay Sievers <kay@vrfy.org>
>> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Rusty Russell <rusty@rustcorp.com.au>
>> ---
>>  include/linux/module.h   |  2 +-
>>  scripts/mod/file2alias.c | 14 +++++++++-----
>>  2 files changed, 10 insertions(+), 6 deletions(-)
>
> Ah, very nice, I've wanted this for a while now, it would make a number
> of different drivers much smaller and simpler to add new device ids to
> (no multiple lists of ids, one for the module loader and one for the
> sub-driver that is in the single file.)

You never asked :(

I've applied, this, but I'm actually amazed this patch works.  C is
weird sometimes.  It changes declarations of the form:

extern const struct pci_device_id __mod_pci_device_id_table
        __attribute__ ((unused, alias("e1000_pci_tbl"));

Into:

extern const struct pci__e1000_pci_tbl_device_id __mod_pci__e1000_pci_tbl_device_id_table
        __attribute__ ((unused, alias("e1000_pci_tbl"));

Now, that's a completely unknown type, but gcc doesn't care because it's
just an extern declaration.  It does insert the alias, which is all we
care about.

We would normally use a special section for this, so it's mainly
historical.  Now we have DEFINE_PCI_DEVICE_TABLE etc, we should
use those to put it in a special section (eg. "pci_ids") and
grab that directly.

Volunteers welcome :)
Rusty.
