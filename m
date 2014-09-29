Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbaI2IlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 04:41:11 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:56725 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaI2IlJ convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Mon, 29 Sep 2014 04:41:09 -0400
Message-Id: <54293742020000780003A48A@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Mon, 29 Sep 2014 09:41:06 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Chen Gang" <gang.chen.5i5j@gmail.com>, "Juergen Gross" <JGross@suse.com>
Cc: "David Vrabel" <david.vrabel@citrix.com>, <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen/xen-scsiback: Need go to fail
 after xenbus_dev_error()
References: <5425967F.7020002@gmail.com> <5428E0ED.1050107@suse.com>
In-Reply-To: <5428E0ED.1050107@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 29.09.14 at 06:32, <JGross@suse.com> wrote:
> On 09/26/2014 06:38 PM, Chen Gang wrote:
>> When failure occurs, after xenbus_dev_error(), need go to fail to let
>> upper caller know about it.
>>
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>> ---
>>   drivers/xen/xen-scsiback.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
>> index 847bc9c..3e430e1 100644
>> --- a/drivers/xen/xen-scsiback.c
>> +++ b/drivers/xen/xen-scsiback.c
>> @@ -1222,8 +1222,10 @@ static int scsiback_probe(struct xenbus_device *dev,
>>
>>   	err = xenbus_printf(XBT_NIL, dev->nodename, "feature-sg-grant", "%u",
>>   			    SG_ALL);
>> -	if (err)
>> +	if (err) {
>>   		xenbus_dev_error(dev, err, "writing feature-sg-grant");
>> +		goto fail;
>> +	}
>>
>>   	xenbus_switch_state(dev, XenbusStateInitWait);
>>   	return 0;
>>
> 
> Hmm, not testing for failure was on purpose. Advertising this feature
> is just for tuning purposes, not mandatory.
> 
> OTOH it would really be a strange error if this xenbus_printf() fails
> but all other operations are working, and signaling an error at the
> time when it first shows up is a good thing. So:

I disagree - failure to announce optional features should not lead to
general failure. And this should be consistent across drivers; for
existing examples see xen_blkbk_flush_diskcache() and
xen_blkbk_discard().

Jan

