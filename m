Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab3HWP4b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 11:56:31 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36911 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab3HWP42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 11:56:28 -0400
Message-ID: <52178628.5020702@wwwdotorg.org>
Date: Fri, 23 Aug 2013 09:56:24 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Richard Zhao <rizhao@nvidia.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "djbw@fb.com" <djbw@fb.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2] DMA: add help function to check whether dma controller
 registered
References: <1375423458-6868-1-git-send-email-rizhao@nvidia.com> <1377153781-18006-1-git-send-email-rizhao@nvidia.com> <52167665.90602@wwwdotorg.org> <20130823011738.GA17925@rizhao-lap>
In-Reply-To: <20130823011738.GA17925@rizhao-lap>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2013 07:17 PM, Richard Zhao wrote:
> On Fri, Aug 23, 2013 at 04:36:53AM +0800, Stephen Warren wrote:
>> On 08/22/2013 12:43 AM, Richard Zhao wrote:
>>> DMA client device driver usually needs to know at probe time whether
>>> dma controller has been registered to deffer probe. So add a help
>>> function of_dma_check_controller.
>>>
>>> DMA request channel functions can also used to check it, but they
>>> are usually called at open() time.
>>
>> This new function is almost identical to the existing
>> of_dma_request_slave_channel(). Surely the code should be shared?
>
> ofdma->of_dma_xlate(&dma_spec, ofdma);
> The above is called holding of_dma_lock. If I want to abstract the
> common lines, there' two options.

What is the problem with acquiring the lock? If request_slave_channel()
needs to take the lock, then there must be a reason which presumably
applies to the other path too.

...
>> But that said, I don't see any need for a new function; why can't
>> drivers simply call of_dma_request_slave_channel() at probe time;
>
> It'll mislead user. channel supposed to be request at open time.

I don't agree.

>> from
>> what I can see, that function doesn't actually request the channel, but
>> rather simply looks it up, just like this one. The only difference is
>> that of_dma_xlate() is also called, but that's just doing some data
>> transformation, not actually recording channel ownership.
>
> xlate function request the channel if things go well.

Oh. xlate should not do that; that's a design flaw. xlate should do
nothing more than translate the DT content to an internal channel ID.
