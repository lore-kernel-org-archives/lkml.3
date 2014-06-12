Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbaFLBDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 21:03:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:17021 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755184AbaFLBDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 21:03:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="353885913"
Message-ID: <5398FC70.8050204@linux.intel.com>
Date: Wed, 11 Jun 2014 18:03:44 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, George Spelvin <linux@horizon.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, price@mit.edu
Subject: Re: drivers/char/random.c: more ruminations
References: <20140611020835.GA23110@thunk.org> <20140611035806.9237.qmail@ns.horizon.com> <20140611131140.GD23110@thunk.org>
In-Reply-To: <20140611131140.GD23110@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2014 06:11 AM, Theodore Ts'o wrote:
> On Tue, Jun 10, 2014 at 11:58:06PM -0400, George Spelvin wrote:
>> You can forbid underflows, but the code doesn't forbid overflows.
>>
>> 1. Assume the entropy count starts at 512 bytes (input pool full)
>> 2. Random writer mixes in 20 bytes of entropy into the input pool.
>> 2a. Input pool entropy is, however, capped at 512 bytes.
>> 3. Random extractor extracts 32 bytes of entropy from the pool.
>>    Succeeds because 32 < 512.  Pool is left with 480 bytes of
>>    entropy.
>> 3a. Random extractor decrements pool entropy estimate to 480 bytes.
>>     This is accurate.
>> 4. Random writer credits pool with 20 bytes of entropy.
>> 5. Input pool entropy is now 480 bytes, estimate is 500 bytes.
> 
> Good point, that's a potential problem, although messing up the
> accounting betewen 480 and 500 bytes is not nearly as bad as messing
> up 0 and 20.
> 
> It's not something where if the changes required massive changes, that
> I'd necessarily feel the need to backport them to stable.  It's a
> certificational weakness, but it's a not disaster.
> 

Actually, with the new accounting code it will be even less serious,
because mixing into a nearly full pool is discounted heavily -- because
it is not like filling a queue; the mixing function will
probabilistically overwrite existing pool entropy.

So it is still a race condition, and still wrong, but it is a lot less
wrong.

	-hpa

