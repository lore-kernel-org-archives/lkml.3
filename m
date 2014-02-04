Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbaBDIC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 03:02:28 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:38144 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbaBDICX (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Tue, 4 Feb 2014 03:02:23 -0500
Message-Id: <52F0AC990200007800118E09@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Tue, 04 Feb 2014 08:02:17 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "=?UTF-8?Q?Roger=20Pau=20Monn=C3=A9?=" <roger.pau@citrix.com>
Cc: "Matt Rushton" <mrushton@amazon.com>, "Matt Wilson" <msw@amazon.com>,
        "DavidVrabel" <david.vrabel@citrix.com>,
        "Ian Campbell" <Ian.Campbell@citrix.com>,
        <xen-devel@lists.xenproject.org>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 3/3] xen-blkback: fix shutdown race
References: <1390931015-5490-1-git-send-email-roger.pau@citrix.com>
 <1390931015-5490-4-git-send-email-roger.pau@citrix.com>
 <52E8CF540200007800117D88@nat28.tlf.novell.com>
 <52EFCACF.6080604@citrix.com>
In-Reply-To: <52EFCACF.6080604@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 03.02.14 at 17:58, Roger Pau Monné<roger.pau@citrix.com> wrote:
> On 29/01/14 09:52, Jan Beulich wrote:
>>>>> On 28.01.14 at 18:43, Roger Pau Monne <roger.pau@citrix.com> wrote:
>>> +		free_req(blkif, pending_req);
>>> +		/*
>>> +		 * Make sure the request is freed before releasing blkif,
>>> +		 * or there could be a race between free_req and the
>>> +		 * cleanup done in xen_blkif_free during shutdown.
>>> +		 *
>>> +		 * NB: The fact that we might try to wake up pending_free_wq
>>> +		 * before drain_complete (in case there's a drain going on)
>>> +		 * it's not a problem with our current implementation
>>> +		 * because we can assure there's no thread waiting on
>>> +		 * pending_free_wq if there's a drain going on, but it has
>>> +		 * to be taken into account if the current model is changed.
>>> +		 */
>>> +		xen_blkif_put(blkif);
>>> +		if (atomic_read(&blkif->refcnt) <= 2) {
>>> +			if (atomic_read(&blkif->drain))
>>> +				complete(&blkif->drain_complete);
>>>  		}
>>> -		free_req(pending_req->blkif, pending_req);
>>>  	}
>>>  }
>> 
>> The put is still too early imo - you're explicitly accessing field in the
>> structure immediately afterwards. This may not be an issue at
>> present, but I think it's at least a latent one.
>> 
>> Apart from that, the two if()s would - at least to me - be more
>> clear if combined into one.
> 
> In order to get rid of the race I had to introduce yet another atomic_t 
> in xen_blkif struct, which is something I don't really like, but I 
> could not see any other way to solve this. If that's fine I will resend 
> the series, here is the reworked patch:

Mind explaining why you can't simply move the xen_blkif_put()
down between the if() and the free_ref().

Jan
