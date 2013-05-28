Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376Ab3E1Xnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 19:43:46 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:47491 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759267Ab3E1Xnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 19:43:45 -0400
MIME-Version: 1.0
In-Reply-To: <51A53F84.2020208@zytor.com>
References: <1369783706-27327-1-git-send-email-yinghai@kernel.org>
	<51A53F84.2020208@zytor.com>
Date: Tue, 28 May 2013 16:43:44 -0700
X-Google-Sender-Auth: euGMfawbZ7GO_XPLUh8tv-mr4Tg
Message-ID: <CAE9FiQXrG0qZ3yJzxsOWhVtzxEY6R9g=sL7EHXZZKNj=BTjmxg@mail.gmail.com>
Subject: Re: [PATCH] x86: Fix adjust_range_size_mask calling position
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 4:36 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 05/28/2013 04:28 PM, Yinghai Lu wrote:
>>
>> Actually there is bug about calling sequence for
>> adjust_range_page_size_mask(). Merge first will make
>> adjust to 1g for second partial 1g range fail.
>>
>
> Sorry, I'm not sure I understand what the above paragraph is trying to say.

We merge the continuous range with same page size allow too early.
in the case
     [mem 0x00200000-0x3fffffff] page 2M
     [mem 0x40000000-0x7bffffff] page 2M
after merging them, will get
     [mem 0x00200000-0x7bffffff] page 2M
even we can use 1G page to map
     [mem 0x40000000-0x7bffffff]

that will cause problem, because we map
     [mem 0x7fe00000-0x7fffffff] page 1G
     [mem 0x7c000000-0x7fdfffff] page 1G
with 1G page.

so need to adjust page size at first before merge
     [mem 0x00200000-0x3fffffff] page 2M
     [mem 0x40000000-0x7bffffff] page 2M

Yinghai
