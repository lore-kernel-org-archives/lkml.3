Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161313Ab3DECQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 22:16:12 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:54381 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161300Ab3DECQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 22:16:11 -0400
Message-ID: <515E33E8.6050507@hitachi.com>
Date: Fri, 05 Apr 2013 11:16:08 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Oskar Andero <oskar.andero@sonymobile.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, davem@davemloft.net,
        anil.s.keshavamurthy@intel.com, ananth@in.ibm.com,
        radovan.lekanovic@sonymobile.com, bjorn.davidsson@sonymobile.com,
        Toby Collett <toby.collett@sonymobile.com>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: Re: [PATCH v2 1/4] kprobes: delay blacklist symbol lookup
 until we actually need it
References: <1365079889-21525-1-git-send-email-oskar.andero@sonymobile.com> <1365079889-21525-2-git-send-email-oskar.andero@sonymobile.com> <20130405005628.GA13624@lge.com>
In-Reply-To: <20130405005628.GA13624@lge.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/05 9:56), Joonsoo Kim wrote:
> Hello, Oskar.
> 
> On Thu, Apr 04, 2013 at 02:51:26PM +0200, Oskar Andero wrote:
>> From: Toby Collett <toby.collett@sonymobile.com>
>>
>> The symbol lookup can take a long time and kprobes is
>> initialised very early in boot, so delay symbol lookup
>> until the blacklist is first used.
>>
>> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> Cc: David S. Miller <davem@davemloft.net>
>> Reviewed-by: Radovan Lekanovic <radovan.lekanovic@sonymobile.com>
>> Signed-off-by: Toby Collett <toby.collett@sonymobile.com>
>> Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
>> ---
>>  kernel/kprobes.c | 98 ++++++++++++++++++++++++++++++++++----------------------
>>  1 file changed, 60 insertions(+), 38 deletions(-)
>>
>> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
>> index e35be53..0a270e5 100644
>> --- a/kernel/kprobes.c
>> +++ b/kernel/kprobes.c
>> @@ -68,6 +68,7 @@
>>  #endif
>>  
>>  static int kprobes_initialized;
>> +static int kprobe_blacklist_initialized;
>>  static struct hlist_head kprobe_table[KPROBE_TABLE_SIZE];
>>  static struct hlist_head kretprobe_inst_table[KPROBE_TABLE_SIZE];
>>  
>> @@ -102,6 +103,60 @@ static struct kprobe_blackpoint kprobe_blacklist[] = {
>>  	{NULL}    /* Terminator */
>>  };
>>  
>> +/* it can take some time ( > 100ms ) to initialise the
>> + * blacklist so we delay this until we actually need it
>> + */
>> +static void init_kprobe_blacklist(void)
>> +{
>> +	int i;
>> +	unsigned long offset = 0, size = 0;
>> +	char *modname, namebuf[128];
>> +	const char *symbol_name;
>> +	void *addr;
>> +	struct kprobe_blackpoint *kb;
>> +
>> +	mutex_lock(&kprobe_mutex);
>> +	if (kprobe_blacklist_initialized)
>> +		goto out;
>> +
>> +	/*
>> +	 * Lookup and populate the kprobe_blacklist.
>> +	 *
>> +	 * Unlike the kretprobe blacklist, we'll need to determine
>> +	 * the range of addresses that belong to the said functions,
>> +	 * since a kprobe need not necessarily be at the beginning
>> +	 * of a function.
>> +	 */
>> +	for (kb = kprobe_blacklist; kb->name != NULL; kb++) {
>> +		kprobe_lookup_name(kb->name, addr);
>> +		if (!addr)
>> +			continue;
>> +
>> +		kb->start_addr = (unsigned long)addr;
>> +		symbol_name = kallsyms_lookup(kb->start_addr,
>> +				&size, &offset, &modname, namebuf);
>> +		if (!symbol_name)
>> +			kb->range = 0;
>> +		else
>> +			kb->range = size;
>> +	}
>> +
>> +	if (kretprobe_blacklist_size) {
>> +		/* lookup the function address from its name */
>> +		for (i = 0; kretprobe_blacklist[i].name != NULL; i++) {
>> +			kprobe_lookup_name(kretprobe_blacklist[i].name,
>> +					   kretprobe_blacklist[i].addr);
>> +			if (!kretprobe_blacklist[i].addr)
>> +				printk("kretprobe: lookup failed: %s\n",
>> +				       kretprobe_blacklist[i].name);
>> +		}
>> +	}
>> +	kprobe_blacklist_initialized = 1;
> 
> You need smp_wmb() before assigning 'kprobe_blacklist_initialized = 1'.
> This guarantee that who see kprobe_blacklist_initialized = 1 will get
> updated data of kprobe_blacklist.

Right, to ensure blacklist is updated, memory barrier is required.

> Please refer my previous patch once more :)
> 
> And How about define kprobe_blacklist_initialized as boolean?

Good idea :)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


