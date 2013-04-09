Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936132Ab3DIV1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 17:27:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:3795 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934470Ab3DIV1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 17:27:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,441,1363158000"; 
   d="scan'208";a="316839201"
Message-ID: <5164884C.70909@intel.com>
Date: Tue, 09 Apr 2013 14:29:48 -0700
From: David Cohen <david.a.cohen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130315 Icedove/17.0.4
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        "Gross, Mark" <mark.gross@intel.com>
Subject: Re: [PATCH] MODSIGN: do not send garbage to stderr when enabling
 modules signature
References: <1365457436-5753-1-git-send-email-david.a.cohen@intel.com> <87mwt88jt2.fsf@rustcorp.com.au>
In-Reply-To: <87mwt88jt2.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 08:27 PM, Rusty Russell wrote:
> David Cohen <david.a.cohen@intel.com> writes:
>> openssl may send garbage to stderr when generating X.509 key pair for
>> modules signature regardless there was an error or not. It makes more
>> difficult to create scripts based on kernel error/warning messages.
>> This patch makes sure openssl logs go to default stdout.
>>
>> Signed-off-by: David Cohen <david.a.cohen@intel.com>
> Can you please give an example of the "garbage" in your commit message,
> or is it binary?

I can write to commit message, it's not binary. I'll send a new patch.

The problem is openssl writes its logs to stderr.
Here's the example I'm going to write to commit message. I captured only 
stderr in this case:

crypto/anubis.c:581: warning: ‘inter’ is used uninitialized in this function
Generating a 4096 bit RSA private key
.........
drivers/gpu/drm/i915/i915_gem_gtt.c: In function ‘gen6_ggtt_insert_entries’:
drivers/gpu/drm/i915/i915_gem_gtt.c:440: warning: ‘addr’ may be used 
uninitialized in this function
.net/mac80211/tx.c: In function ‘ieee80211_subif_start_xmit’:
net/mac80211/tx.c:1780: warning: ‘chanctx_conf’ may be used 
uninitialized in this function
..drivers/isdn/hardware/mISDN/hfcpci.c: In function ‘hfcpci_softirq’:
.....drivers/isdn/hardware/mISDN/hfcpci.c:2298: warning: ignoring return 
value of ‘driver_for_each_device’, declared with attribute 
warn_unused_result
net/unix/af_unix.c: In function ‘unix_bind’:
net/unix/af_unix.c:892: warning: ‘path.dentry’ may be used uninitialized 
in this function
net/unix/af_unix.c:892: warning: ‘path.mnt’ may be used uninitialized in 
this function
...++
In file included from drivers/message/i2o/config-osm.c:39:
drivers/message/i2o/i2o_config.c: In function ‘i2o_cfg_passthru’:
drivers/message/i2o/i2o_config.c:888: warning: cast to pointer from 
integer of different size
drivers/message/i2o/i2o_config.c:943: warning: cast to pointer from 
integer of different size
drivers/net/ethernet/amd/nmclan_cs.c: In function ‘nmclan_config’:
drivers/net/ethernet/amd/nmclan_cs.c:625: warning: 
‘pcmcia_request_exclusive_irq’ is deprecated (declared at 
include/pcmcia/ds.h:201)
drivers/net/ethernet/mellanox/mlx4/mcg.c: In function ‘find_entry’:
.........................................................................................................................................................................................++
writing new private key to 'signing_key.priv'
-----
drivers/net/ethernet/mellanox/mlx4/mcg.c:601: warning: ‘hash’ may be 
used uninitialized in this function


The problem happens when we use high N value on make -jN. All warnings 
get mixed with dots and other outputs from openssl when printed during 
key pair generation.

Br, David


>
> Thanks,
> Rusty,.
>
>> ---
>>   kernel/Makefile |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/Makefile b/kernel/Makefile
>> index bbde5f1..5a51e6c 100644
>> --- a/kernel/Makefile
>> +++ b/kernel/Makefile
>> @@ -175,7 +175,7 @@ signing_key.priv signing_key.x509: x509.genkey
>>   	openssl req -new -nodes -utf8 -$(CONFIG_MODULE_SIG_HASH) -days 36500 \
>>   		-batch -x509 -config x509.genkey \
>>   		-outform DER -out signing_key.x509 \
>> -		-keyout signing_key.priv
>> +		-keyout signing_key.priv 2>&1
>>   	@echo "###"
>>   	@echo "### Key pair generated."
>>   	@echo "###"
>> -- 
>> 1.7.10.4

