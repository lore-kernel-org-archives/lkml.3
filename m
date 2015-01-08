Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179AbbAHOqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 09:46:23 -0500
Received: from mga09.intel.com ([134.134.136.24]:24220 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753877AbbAHOqW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 09:46:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,723,1413270000"; 
   d="scan'208";a="648166888"
From: "Ong, Boon Leong" <boon.leong.ong@intel.com>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "dvhart@infradead.org" <dvhart@infradead.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>
Subject: RE: [PATCH 1/2] x86: Add Isolated Memory Regions for Quark X1000
Thread-Topic: [PATCH 1/2] x86: Add Isolated Memory Regions for Quark X1000
Thread-Index: AQHQI41CoFze/rj2YEaQrKcsZxtS4py1Md6QgACJMwCAAJ2lcA==
Date: Thu, 8 Jan 2015 14:45:49 +0000
Message-ID: <AF233D1473C1364ABD51D28909A1B1B7326E297E@PGSMSX105.gar.corp.intel.com>
References: <1419873783-5161-1-git-send-email-pure.logic@nexus-software.ie>
 <1419873783-5161-2-git-send-email-pure.logic@nexus-software.ie>
 <AF233D1473C1364ABD51D28909A1B1B7326E0CC8@PGSMSX105.gar.corp.intel.com>
 <54AE8136.2060400@nexus-software.ie>
In-Reply-To: <54AE8136.2060400@nexus-software.ie>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> +/**
>>> + * imr_del_range - Delete an Isolated Memory Region
>>> + * @reg: IMR index to remove
>>> + * @base: Physical base address of region aligned to 4k
>>> + * @size: Physical size of region in bytes
>>> + * @return:	-EINVAL on invalid range or out or range id
>>> + *		-ENODEV if reg is valid but no IMR exists or is locked
>>> + *		0 on success
>>> + */
>>> +int imr_del(int reg, unsigned long base, unsigned long size);
>>
>> How about just offer imr delete based index-only as returned by imr_add()?
>> We just need to check if that IMR is locked. If locked, then bail out.
>> Else, we will zero-out IMR register for that index to remove it.
>
>Hmm.
>
>The MTRR API this is based on allows you to specific an address range and I think
>that makes sense for an IMR API too because - say you want to tear down the
>IMR around the kernel .text area - but you don't know which IMR it is.
>
>You'd just do
>
>unsigned long base  = virt_to_phys(&_text); unsigned long size =
>virt_to_phys(&_sinittext) - base - IMR_ALIGN;
>
>imr_del(-1, base, size);
>
>Rather than having to know which specific index to kill. Also later silicon may
>have more - or less IMR indices - so deleting based on an address range is a
>valuable feature I think.

imr_add() returns IMR index, so I would expect that I can use the index directly
if I need to remove it. 

Suggest to split the imr_del() into 2 functions:- 
(1) by address + size 
(2) by IMR index
At current implementation, it does not support (2) only because it fails at 
imr_check_range().
