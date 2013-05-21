Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab3EUURJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 16:17:09 -0400
Received: from mail-gg0-f171.google.com ([209.85.161.171]:60013 "EHLO
	mail-gg0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab3EUURH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 16:17:07 -0400
Message-ID: <519BD640.4040102@gmail.com>
Date: Tue, 21 May 2013 16:17:04 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Karel Zak <kzak@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Rafael Aquini <aquini@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org, hughd@google.com,
        shli@kernel.org, jmoyer@redhat.com, riel@redhat.com,
        lwoodman@redhat.com, mgorman@suse.de
Subject: Re: [RFC PATCH 02/02] swapon: add "cluster-discard" support
References: <cover.1369092449.git.aquini@redhat.com> <398ace0dd3ca1283372b3aad3fceeee59f6897d7.1369084886.git.aquini@redhat.com> <519AC7B3.5060902@gmail.com> <20130521102648.GB11774@x2.net.home>
In-Reply-To: <20130521102648.GB11774@x2.net.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(5/21/13 6:26 AM), Karel Zak wrote:
> On Mon, May 20, 2013 at 09:02:43PM -0400, KOSAKI Motohiro wrote:
>>> -	if (fl_discard)
>>> +	if (fl_discard) {
>>>  		flags |= SWAP_FLAG_DISCARD;
>>> +		if (fl_discard > 1)
>>> +			flags |= SWAP_FLAG_DISCARD_CLUSTER;
>>
>> This is not enough, IMHO. When running this code on old kernel, swapon() return EINVAL.
>> At that time, we should fall back swapon(0x10000).
> 
>  Hmm.. currently we don't use any fallback for any swap flag (e.g.
>  0x10000) for compatibility with old kernels. Maybe it's better to
>  keep it simple and stupid and return an error message than introduce
>  any super-smart semantic to hide incompatible fstab configuration.

Hm. If so, I'd propose to revert the following change. 

> .B "\-d, \-\-discard"
>-Discard freed swap pages before they are reused, if the swap
>-device supports the discard or trim operation.  This may improve
>-performance on some Solid State Devices, but often it does not.
>+Enables swap discards, if the swap device supports that, and performs
>+a batch discard operation for the swap device at swapon time.


And instead, I suggest to make --discard-on-swapon like the following.
(better name idea is welcome) 

+--discard-on-swapon
+Enables swap discards, if the swap device supports that, and performs
+a batch discard operation for the swap device at swapon time.

I mean, preserving flags semantics removes the reason we need make a fallback.


