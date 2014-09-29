Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbaI2JfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 05:35:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52642 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbaI2JfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 05:35:05 -0400
Message-ID: <542927C3.8010204@suse.com>
Date: Mon, 29 Sep 2014 11:34:59 +0200
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>, Jan Beulich <JBeulich@suse.com>
CC: David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xenproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen/xen-scsiback: Need go to fail after xenbus_dev_error()
References: <5425967F.7020002@gmail.com> <5428E0ED.1050107@suse.com> <54293742020000780003A48A@mail.emea.novell.com> <54292707.90008@gmail.com>
In-Reply-To: <54292707.90008@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2014 11:31 AM, Chen Gang wrote:
> On 9/29/14 16:41, Jan Beulich wrote:
>>>>> On 29.09.14 at 06:32, <JGross@suse.com> wrote:
>>> On 09/26/2014 06:38 PM, Chen Gang wrote:
>>>> When failure occurs, after xenbus_dev_error(), need go to fail to let
>>>> upper caller know about it.
>>>>
>>>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>>>> ---
>>>>    drivers/xen/xen-scsiback.c | 4 +++-
>>>>    1 file changed, 3 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
>>>> index 847bc9c..3e430e1 100644
>>>> --- a/drivers/xen/xen-scsiback.c
>>>> +++ b/drivers/xen/xen-scsiback.c
>>>> @@ -1222,8 +1222,10 @@ static int scsiback_probe(struct xenbus_device *dev,
>>>>
>>>>    	err = xenbus_printf(XBT_NIL, dev->nodename, "feature-sg-grant", "%u",
>>>>    			    SG_ALL);
>>>> -	if (err)
>>>> +	if (err) {
>>>>    		xenbus_dev_error(dev, err, "writing feature-sg-grant");
>>>> +		goto fail;
>>>> +	}
>>>>
>>>>    	xenbus_switch_state(dev, XenbusStateInitWait);
>>>>    	return 0;
>>>>
>>>
>>> Hmm, not testing for failure was on purpose. Advertising this feature
>>> is just for tuning purposes, not mandatory.
>>>
>>> OTOH it would really be a strange error if this xenbus_printf() fails
>>> but all other operations are working, and signaling an error at the
>>> time when it first shows up is a good thing. So:
>>
>> I disagree - failure to announce optional features should not lead to
>> general failure. And this should be consistent across drivers; for
>> existing examples see xen_blkbk_flush_diskcache() and
>> xen_blkbk_discard().
>>
>
> During scsiback_probe(), can we sure that "feature-sg-grant" is optional
> feature? For me, only according to its name, I guess not: it is about
> security which is always necessary in kernel (although SG_ALL).

It is optional. Otherwise the interface would be broken, as I've added
this feature recently and "old" clients (pre 3.18) don't know about it.

The feature is NOT about security, but about capability to support
larger SCSI requests than the old interface did.


Juergen

