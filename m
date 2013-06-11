Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab3FKNSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 09:18:09 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:44618 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab3FKNSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 09:18:07 -0400
Message-ID: <51B72382.7060702@oracle.com>
Date: Tue, 11 Jun 2013 09:17:54 -0400
From: konrad wilk <konrad.wilk@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: david.vrabel@citrix.com, roger.pau@citrix.com,
        xen-devel <xen-devel@lists.xen.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] xen/blkback: Check for insane amounts of request on the
 ring.
References: <1370375826-7311-1-git-send-email-konrad.wilk@oracle.com> <20130607201140.GA22115@phenom.dumpdata.com> <51B6126302000078000DCC1C@nat28.tlf.novell.com> <20130610164319.GB24467@phenom.dumpdata.com> <51B6F11D02000078000DCFD0@nat28.tlf.novell.com>
In-Reply-To: <51B6F11D02000078000DCFD0@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 6/11/2013 3:42 AM, Jan Beulich wrote:
>>>> On 10.06.13 at 18:43, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
>> On Mon, Jun 10, 2013 at 04:52:35PM +0100, Jan Beulich wrote:
>>>>>> On 07.06.13 at 22:11, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
>>>> On Tue, Jun 04, 2013 at 03:57:06PM -0400, Konrad Rzeszutek Wilk wrote:
>>>>> +	/* N.B. 'rp', not 'rc'. */
>>>>> +	if (RING_REQUEST_CONS_OVERFLOW(&blk_rings->common, rp)) {
>>>>> +		pr_warn(DRV_PFX "Frontend provided bogus ring requests (%d - %d = %d).
>>>> Halting ring processing on dev=%04x\n",
>>>>> +			rp, rc, rp - rc, blkif->vbd.pdevice);
>>>> Hm, I seem to be able to get:
>>>>
>>>> [  189.398095] xen-blkback:Frontend provided bogus ring requests (125 - 115 =
>>>> 10). Halting ring processing on dev=800011
>>>> or:
>>>> [  478.558699] xen-blkback:Frontend provided bogus ring requests (95 - 94 =
>>>> 1). Halting ring processing on dev=800011
>>>>
>>>> Which is clearly wrong. Piggybacking on the rsp_prod_pvt does not seem to
>>>> cut it.
>>> We see that too, but not very frequently. One thing is that
>>> rsp_prod_pvt doesn't get printed along with rc and rp, thus
>>> making it not immediately obvious how this can be off in any way.
>>>
>>> Among the instance there are cases where the printed
>>> difference is 32, which makes me wonder whether part of the
>>> problem is the >= in the macro (we may want > here).
>>>
>>> And then we might have been living with some sort of issue in the
>>> past, because the existing use of the macro just causes the loop
>>> to be exited, with it getting re-entered subsequently (i.e. at worst
>>> causing performance issues).
>> My observation was that the rsp_prod_pvt was lagging behind b/c the
>> READ requests weren't completed. In other words, the processing
>> of the ring was stalled b/c 'make_response' hadn't been called yet.
>> Which meant that rsp_prod was not updated to rsp_prod_pvt (backend
>> does not care about that value, only frontend does).
> I don't buy this: rsp_prod is being updated by the backend just for
> the frontend's sake, so this value really doesn't need looking at (or
> else we'd become susceptible to the guest maliciously writing that
> field).
>
> rsp_prod_pvt, otoh, is never behind rsp_prod, and if the guest
> produces requests that don't have matching space for responses,
> the guest is doing something bogus (and perhaps malicious).

I believe this is what I saw with the rsp_prod_pvt added in the printk. 
Unfortunately I did not save the logs.
>
>> Going back to the rc an rp check solves the immediate 'insane ring
>> check'.
> Consequently, while this check is better than none at all, I think it
> is still too lax, and we really want to check against the produced
> responses. Just that other than for the rc check using >=, we'd
> need > for the rp one.
>
> But first of all let me see if I can get the original broken check to
> trigger wrongly here (so far only our stage testing caught these),
> and look at by how much rsp_prod_pvt really lags.

OK.
>
> Jan
>

