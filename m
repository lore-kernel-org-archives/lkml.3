Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab3HFIUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 04:20:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58829 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754480Ab3HFIUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 04:20:24 -0400
Message-ID: <5200B1BF.2060009@suse.cz>
Date: Tue, 06 Aug 2013 10:20:15 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: Warnings from silentoldconfig (Re: [GIT PULL] PCI updates for
 v3.11)
References: <20130802181740.GA27100@google.com> <CA+55aFzSG8ny=79_MFik5xP99c7eb-LMKh0JzTKpbiEB8Wt=5Q@mail.gmail.com> <20130805083943.GA14782@sepie.suse.cz> <20130805225830.GA29411@free.fr>
In-Reply-To: <20130805225830.GA29411@free.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6.8.2013 00:58, Yann E. MORIN wrote:
> On 2013-08-05 10:39 +0200, Michal Marek spake thusly:
>> Added Yann and the linux-kbuild list to CC. Reproducer:
>>
>>   git checkout 1fe0135
>>   make mrproper
>>   make allmodconfig
>>   make silentoldconfig
>>   git checkout aa8032b
>>   make allmodconfig
>>   make silentoldconfig
>>
>> conf_write_autoconf() first calls conf_split_config() to generate the
>> include/config/**.h hierarchy, then generates include/config/auto.conf.
>> For some reason, conf_split_config() reads include/config/auto.conf,
>> which may not exist yet or may be out of date. Yann, can anything break
>> if we simply do not read that file from conf_split_config(), like this?
>>
>> diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
>> index c55c227..8c90835 100644
>> --- a/scripts/kconfig/confdata.c
>> +++ b/scripts/kconfig/confdata.c
>> @@ -829,16 +829,12 @@ next:
>>  
>>  static int conf_split_config(void)
>>  {
>> -	const char *name;
>>  	char path[PATH_MAX+1];
>>  	char *s, *d, c;
>>  	struct symbol *sym;
>>  	struct stat sb;
>>  	int res, i, fd;
>>  
>> -	name = conf_get_autoconfig_name();
>> -	conf_read_simple(name, S_DEF_AUTO);
>> -
>>  	if (chdir("include/config"))
>>  		return 1;
[...]
> 
> What I understand of the code is that, we're reading auto.conf with
> the S_DEF_AUTO flag, which is expected to set the SYMBOL_DEF_AUTO flags
> to symbols read from auto.conf.
> 
> This is then used by conf_split_config to detect symbols that have
> changed.

Ah, _that_ is why it's there.

[...]
> The two following tests do not invlolve the HOTPLUG_PCI_.* symbols
> on purpose, and involve a pristine master c095ba7:
> 
>     $ make allmodconfig
>     $ make silentoldconfig
>     $ make silentoldconfig
>     $ make silentoldconfig
> 
>   - Without Michal's proposed change, unaffected symbols are not
>     touched. For example, mtime and ctime for zswap.h are not changed
>     after the second and third silentoldconfig.
> 
>   - With Michal's proposed change, then mtime and ctime for zswap.h are
>     changed after each silentoldconfig, even though CONFIG_ZSWAP was not
>     changed.

Yes, I only did a simple diff -rq between two generated include/config
directories and did not think about mtimes.


> One solution would be to read auto.conf *before* we fuzz around symbols,
> not after. We should probably read auto.conf just after we read .config.

Maybe the safest solution would be to silence the warning if def ==
S_DEF_AUTO. Because auto.conf is only read by kconfig in
conf_split_config(), when it is expected to be out of date.

Michal
