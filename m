Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbaBUXBh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 18:01:37 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:50389 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754226AbaBUXBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 18:01:35 -0500
Message-ID: <5307DAC9.2020103@hurleysoftware.com>
Date: Fri, 21 Feb 2014 18:01:29 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, Chris Boot <bootc@bootc.net>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH 4/9] firewire: don't use PREPARE_DELAYED_WORK
References: <1392929071-16555-5-git-send-email-tj@kernel.org> <5306AF8E.3080006@hurleysoftware.com> <20140221015935.GF6897@htj.dyndns.org> <5306B4DF.4000901@hurleysoftware.com> <20140221021341.GG6897@htj.dyndns.org> <5306E06C.5020805@hurleysoftware.com> <20140221100301.GA14653@mtj.dyndns.org> <53074BE4.1020307@hurleysoftware.com> <20140221130614.GH6897@htj.dyndns.org> <5307849A.9050209@hurleysoftware.com> <20140221165730.GA10929@htj.dyndns.org>
In-Reply-To: <20140221165730.GA10929@htj.dyndns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2014 11:57 AM, Tejun Heo wrote:
> Yo,
>
> On Fri, Feb 21, 2014 at 11:53:46AM -0500, Peter Hurley wrote:
>> Ok, I can do that. But AFAIK it'll have to be an smp_rmb(); there is
>> no mb__after unlock.
>
> We do have smp_mb__after_unlock_lock().
>
>> [ After thinking about it some, I don't think preventing speculative
>>    writes before clearing PENDING if useful or necessary, so that's
>>    why I'm suggesting only the rmb. ]
>
> But smp_mb__after_unlock_lock() would be cheaper on most popular
> archs, I think.

smp_mb__after_unlock_lock() is only for ordering memory operations
between two spin-locked sections on either the same lock or by
the same task/cpu. Like:

    i = 1
    spin_unlock(lock1)
    spin_lock(lock2)
    smp_mb__after_unlock_lock()
    j = 1

This guarantees that the store to j happens after the store to i.
Without it, a cpu can

    spin_lock(lock2)
    j = 1
    i = 1
    spin_unlock(lock1)

Regards,
Peter Hurley
