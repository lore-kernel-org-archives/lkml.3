Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab3COTiz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:38:55 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55507 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab3COTiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:38:54 -0400
Message-ID: <514378CB.1060605@wwwdotorg.org>
Date: Fri, 15 Mar 2013 13:38:51 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Bill Huang <bilhuang@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC 1/1] clk: Add notifier support in clk_prepare_enable/clk_disable_unprepare
References: <1363151317.3311.9.camel@bilhuang-vm1> <51400D9D.9060305@wwwdotorg.org> <1363153204.3311.14.camel@bilhuang-vm1> <5140C12A.4060900@wwwdotorg.org> <1363227311.3311.30.camel@bilhuang-vm1> <20130314092132.GE18519@tbergstrom-lnx.Nvidia.com> <1363253287.3311.32.camel@bilhuang-vm1> <51420EBB.7080503@wwwdotorg.org> <1363310454.3311.44.camel@bilhuang-vm1> <5142B027.4040403@wwwdotorg.org> <20130315093951.GV18519@tbergstrom-lnx.Nvidia.com> <CAPDyKFoBJpraMz8i1FmFqG7=Zsv0DTQ0PKVOQJ-+iEsKpb3Hdg@mail.gmail.com> <1363349206.5827.10.camel@bilhuang-vm1> <CAPDyKFpHz6KCNbVe2AsDuzZw-oN7NyRzCA=RatWA+9iMaQ7C+Q@mail.gmail.com>
In-Reply-To: <CAPDyKFpHz6KCNbVe2AsDuzZw-oN7NyRzCA=RatWA+9iMaQ7C+Q@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2013 06:33 AM, Ulf Hansson wrote:
> On 15 March 2013 13:06, Bill Huang <bilhuang@nvidia.com> wrote:
>> On Fri, 2013-03-15 at 18:08 +0800, Ulf Hansson wrote:
...
>>> Some prerequisites; I think am in favor of using the clk API to
>>> trigger DVFS changes and then I agree on that clk_prepare|unprepare
>>> needs to be possible to track from a DVFS perspective. clk_set_rate is
>>> not enough.
>>>
>>> So if we decide to do the above (using the clk API to trigger DVFS
>>> changes), I believe we should discuss two possible solutions;
>>> - clk notifiers or..
>>> - dvfs clock type.
>>>
>>> I am trying to make up my mind of what I think is the best solution.
>>> Have you considered "dvfs clock type"?
>>> I put some comments about this for "[PATCH 2/5] clk: notifier handler
>>> for dynamic voltage scaling" recently as well.
>>>
>>> What could the advantages/disadvantages be between the two options?
>>
>> I personally prefer clk notifiers since that's easy and all the existing
>> device drivers don't need to be modified, a new clock or API might be
>> more thoroughly considered (and hence maybe more graceful) but that
>> means we need more time to cook and many drivers need to plug into that
>> API when it comes out, a lot of test/verification or maybe chaos
>> follows, I'm not sure will that be a little overkill.
> 
> I guess you did not fully got what I meant with "dvfs clock type". It
> will not affect the clock API. But instead the dvfs is handled by
> implementing a specific clk hw type. So the same thing is accomplished
> as with clk notifiers, no changes should be needed to device drivers.
> 
> The difference is only that no notifiers will be needed, and all the
> dvfs stuff will be handled in the clk hw instead. It will mean that we
> will bundle dvfs stuff into the clock drivers, instead of separating
> the code outside the clock drivers. But, on the other hand no
> notifiers will be needed.

The advantage here is that I assume that a notifier would continually
have to check whether the clock being modified was one that the DVFS
notifier cared about. By integrating the CVFS logic into the clk_hw
itself, it'll only ever get executed for clocks that really care about
DVFS. Presumably, the code that implements the clk_hw could also use
some common DVFS library as part of the implementation, and still share
code. Or perhaps, what about putting DVFS "ops" into a clk_hw alongside
any other existing ops, and having the clock core call them whenever
appropriate?
