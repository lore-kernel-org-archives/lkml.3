Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbaHKTA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 15:00:57 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:51620 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaHKTA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 15:00:56 -0400
Message-ID: <53E912E3.8010808@gmail.com>
Date: Mon, 11 Aug 2014 12:00:51 -0700
From: Matthew Rushton <mvrushton@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Matt Wilson <msw@linux.com>
CC: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, msw@amazon.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, Matt Rushton <mrushton@amazon.com>
Subject: Re: [PATCH v3 2/2] xen/setup: Remap Xen Identity Mapped RAM
References: <1407778441-26604-1-git-send-email-mrushton@amazon.com> <1407778441-26604-2-git-send-email-mrushton@amazon.com> <20140811174124.GA3156@u109add4315675089e695.ant.amazon.com>
In-Reply-To: <20140811174124.GA3156@u109add4315675089e695.ant.amazon.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/14 10:41, Matt Wilson wrote:
> On Mon, Aug 11, 2014 at 10:34:01AM -0700, Matt Rushton wrote:
>> Instead of ballooning up and down dom0 memory this remaps the existing mfns
>> that were replaced by the identity map. The reason for this is that the
>> existing implementation ballooned memory up and and down which caused dom0
>> to have discontiguous pages. In some cases this resulted in the use of bounce
>> buffers which reduced network I/O performance significantly. This change will
>> honor the existing order of the pages with the exception of some boundary
>> conditions.
>>
>> To do this we need to update both the Linux p2m table and the Xen m2p table.
>> Particular care must be taken when updating the p2m table since it's important
>> to limit table memory consumption and reuse the existing leaf pages which get
>> freed when an entire leaf page is set to the identity map. To implement this,
>> mapping updates are grouped into blocks with table entries getting cached
>> temporarily and then released.
>>
>> On my test system before:
>> Total pages: 2105014
>> Total contiguous: 1640635
>>
>> After:
>> Total pages: 2105014
>> Total contiguous: 2098904
>>
>> Signed-off-by: Matthew Rushton <mrushton@amazon.com>
>> ---
> Matt,
>
> Could you provide a summary of v2->v3 changes here?
>
> --msw
>
>>   arch/x86/xen/p2m.c   |   23 +---
>>   arch/x86/xen/p2m.h   |   15 ++
>>   arch/x86/xen/setup.c |  370 +++++++++++++++++++++++++++++++++++++++-----------
>>   3 files changed, 314 insertions(+), 94 deletions(-)
>>   create mode 100644 arch/x86/xen/p2m.h
Resent patch set with:

v3: One line change to fix 32-bit mfn casting issue with MMU_MACHPHYS_UPDATE

