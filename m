Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbaIMB70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 21:59:26 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:63882 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbaIMB7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 21:59:24 -0400
MIME-Version: 1.0
In-Reply-To: <ghk358crbe.fsf@quad.gouders.net>
References: <ghiol53r9u.fsf@lena.gouders.net>
	<CAMxnaaXiEZeJOsgQ6ZSbiqy5Z1zNoXonwNSQNRyRhV0t5jveYQ@mail.gmail.com>
	<ghwq9k3m6z.fsf@lena.gouders.net>
	<CAMxnaaUqTMf1uEQUqrAGjym8ZrQaBf2QbE4Jqxh2t6a2JgJkOQ@mail.gmail.com>
	<ghioku5l29.fsf@lena.gouders.net>
	<CAErSpo7j=a3y2MVsvEQGQ4B63_mNCyZSRNXNEZa-2++xs88NmQ@mail.gmail.com>
	<CAE9FiQUXvuZo2bQSRg0vpuDVYrnkcXDu7KZBNp-YgXbKa2LQhw@mail.gmail.com>
	<ghppf15236.fsf@quad.gouders.net>
	<CAErSpo5SVUOz+qa_x5JTC+-Y5ewTyYzA0N=jyPtK9LaguRrt=w@mail.gmail.com>
	<ghd2b1svdw.fsf@quad.gouders.net>
	<CAErSpo5e0GOdVbZdQYriP+aWziKELpb9BWTgJ4ERPia354CM5w@mail.gmail.com>
	<ghvbotd8es.fsf@quad.gouders.net>
	<ghzje5f5zt.fsf@lena.gouders.net>
	<ghbnqkeh9k.fsf@quad.gouders.net>
	<CAE9FiQXQesrDMqf1b6ZhHdmY_wEEUrOEvNO4N_d6WtaNMGNLww@mail.gmail.com>
	<gh4mwcef0r.fsf@quad.gouders.net>
	<CAE9FiQWgioBeVmfWCaE38BrkjbWKaS+_FYYdmdd+7X8fpeEgnQ@mail.gmail.com>
	<ghoaukcx6b.fsf@quad.gouders.net>
	<CAE9FiQUk-sAHnjfBvNeHQWibJRqbPE1V0UtDtARtwxmS=7aQrw@mail.gmail.com>
	<ghk358crbe.fsf@quad.gouders.net>
Date: Fri, 12 Sep 2014 18:59:23 -0700
X-Google-Sender-Auth: D5GWU9KeLRSDD4YguUBGDZ-0vrc
Message-ID: <CAE9FiQUeP84585-4b+Y6WBVD3zqOi7ch_OXytsTmKEz9AyZ3Vg@mail.gmail.com>
Subject: Re: [BUG] Bisected Problem with LSI PCI FC Adapter
From: Yinghai Lu <yinghai@kernel.org>
To: Dirk Gouders <dirk@gouders.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 5:11 PM, Dirk Gouders <dirk@gouders.net> wrote:
> Yinghai Lu <yinghai@kernel.org> writes:
>
> Yes, I skip them in pci_scan_device() to get the unused bus number space
> that 0a.0 and 0b.0 then can use when reconfiguration is triggered.

That is not right. Can not let two bridges use same bus num.

>
>> Proper simulation could be:
>> 1. remove 07:00.0
>>     echo 1 > /sys/bus/pci/devices/0000:07:00.0/remove
>> 2. change bus range in 00:0a.0 bus
>>     setpci -s 00:0a.0 0x1c.l=0x00101000
>> 3. remove 00:0a.0
>>     echo 1 > /sys/bus/pci/devices/0000:00:0a.0/remove
>> 4. rescan pci
>>     echo 1 > /sys/bus/pci/rescan
>> 5. reset pcie link from 00:0a.0
>>     setpci -s 00:0a.0 0xc0.b=0x18
>>     sleep 1s
>>     setpci -s 00:0a.0 0xc0.b=0x08
>> 6. rescan pci bus
>>     echo 1 > /sys/bus/pci/rescan
>
> OK, I did that (with 3.16) but the reconfiguration code doesn't
> get triggered.  Here is what dmesg and lspci -tv say:

2 should be
   setpci -s 00:0a.0 0x18.l=0x00101000
