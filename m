Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382AbaDHQ0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 12:26:49 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:49039 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117AbaDHQ0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 12:26:47 -0400
Message-ID: <53442344.8000801@mm-sol.com>
Date: Tue, 08 Apr 2014 19:26:44 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Courtney Cavin <courtney.cavin@sonymobile.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH 1/9] crypto: qce: Add core driver implementation
References: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com> <1396541886-10966-2-git-send-email-svarbanov@mm-sol.com> <20140403233844.GF17066@sonymobile.com>
In-Reply-To: <20140403233844.GF17066@sonymobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Courtney,

Thanks for the review!

On 04/04/2014 02:38 AM, Courtney Cavin wrote:
> On Thu, Apr 03, 2014 at 06:17:58PM +0200, Stanimir Varbanov wrote:
>> This adds core driver files. The core part is implementing a
>> platform driver probe and remove callbaks, the probe enables
>> clocks, checks crypto version, initialize and request dma
>> channels, create done tasklet and work queue and finally
>> register the algorithms into crypto subsystem.
>>
>> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
>> ---
>>  drivers/crypto/qce/core.c | 333 ++++++++++++++++++++++++++++++++++++++++++++++
>>  drivers/crypto/qce/core.h |  69 ++++++++++
>>  2 files changed, 402 insertions(+)
>>  create mode 100644 drivers/crypto/qce/core.c
>>  create mode 100644 drivers/crypto/qce/core.h
>>
>> diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
> [...]
>> +static struct qce_algo_ops qce_ops[] = {
>> +	{
>> +		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
>> +		.register_alg = qce_ablkcipher_register,
>> +	},
>> +	{
>> +		.type = CRYPTO_ALG_TYPE_AHASH,
>> +		.register_alg = qce_ahash_register,
>> +	},
>> +};
>> +
>> +static void qce_unregister_algs(struct qce_device *qce)
>> +{
>> +	struct qce_alg_template *tmpl, *n;
>> +
>> +	list_for_each_entry_safe(tmpl, n, &qce->alg_list, entry) {
>> +		if (tmpl->crypto_alg_type == CRYPTO_ALG_TYPE_AHASH)
>> +			crypto_unregister_ahash(&tmpl->alg.ahash);
>> +		else
>> +			crypto_unregister_alg(&tmpl->alg.crypto);
>> +
>> +		list_del(&tmpl->entry);
>> +		kfree(tmpl);
> 
> I find this whole memory/list management to be very disorganised.
> ops->register_alg() is supposed to allocate this item--more precisely,
> multiple items--using something that must be able to be kfree'd
> directly, register it with the crypto core, and put it on this list
> manually.  Here we unregister/remove/free this in the core.  Josh's
> recommendation of a unregister_alg callback might help, but it all
> remains a bit unclear with register_alg/unregister_alg managing X
> algorithms per call. 
> 
> Additionally, above you have qce_ops, which clearly defines the
> operations for specific algorithms types/groups, which in later patches
> are shown to be seperated out into independent implementations.
> 
> From what I can tell, this seems to be a framework with built-in yet
> independent crypto implementations which call the crypto API directly.
> 
> It would be more logical to me if this was seperated out into a
> "library/core" API, with the individual implementations as platform
> drivers of their own.  Then they can register with the core, managing
> memory how they please.
> 
> What am I missing?
> 

No, you have not miss nothing.

OK I see your point. I made few changes in the core, killed the alg_list
and its manipulation function and added a .unregister_algs operation.
Now every type of algorithm will handle all core crypto api functions
itself. Also I'm using devm_kzalloc() in .register_algs when allocating
memory for qce_alg_template structures to avoid kfree(). The callbacks
async_req_queue/done are now embedded in qce_device structure and they
are invoked directly from algorithm implementations. Thus I have
separated the interfaces: functions implemented in core part of the
driver and struct qce_algo_ops having the function pointers implemented
by every type of algorithm.

If you don't have some objections I can send out a version 2.

-- 
regards,
Stan
