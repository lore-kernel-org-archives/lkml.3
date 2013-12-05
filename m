Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab3LEI5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 03:57:41 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:27385 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751053Ab3LEI5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 03:57:40 -0500
X-IronPort-AV: E=Sophos;i="4.93,831,1378828800"; 
   d="scan'208";a="9197592"
Message-ID: <52A0F663.4060705@cn.fujitsu.com>
Date: Thu, 05 Dec 2013 16:55:47 -0500
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: dsahern@gmail.com, jolsa@redhat.com, Ingo Molnar <mingo@kernel.org>,
        a.p.zijlstra@chello.nl, paulus@samba.org, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@iki.fi>, Zhang@infradead.org,
        Yanmin <yanmin_zhang@linux.intel.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/5] perf tools: Update the Document for perf kvm record
 for new behavior.
References: <cover.1386197481.git.yangds.fnst@cn.fujitsu.com> <3a3a9c1e05acb5a274d1d8369db5a4c6467d6276.1386197481.git.yangds.fnst@cn.fujitsu.com> <20131204142745.GG6359@ghostprotocols.net>
In-Reply-To: <20131204142745.GG6359@ghostprotocols.net>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/05 16:57:22,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/05 16:57:29,
	Serialize complete at 2013/12/05 16:57:29
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2013 09:27 AM, Arnaldo Carvalho de Melo wrote:
> Em Wed, Dec 04, 2013 at 05:56:41PM -0500, Dongsheng Yang escreveu:
>> As we have changed the default behavior of perf kvm to --guest enabled,
>> the document about perf kvm record is outdated. This patch update it to
>> show the correct output with --host/--guest/neither/both of them.
>   
>> +++ b/tools/perf/Documentation/perf-kvm.txt
>> @@ -24,10 +24,17 @@ There are a couple of variants of perf kvm:
>>     of an arbitrary workload.
>    
>>     'perf kvm record <command>' to record the performance counter profile
>> -  of an arbitrary workload and save it into a perf data file. If both
>> -  --host and --guest are input, the perf data file name is perf.data.kvm.
>> -  If there is  no --host but --guest, the file name is perf.data.guest.
>> -  If there is no --guest but --host, the file name is perf.data.host.
>> +  of an arbitrary workload and save it into a perf data file. We set the
>> +  default behavior of perf kvm as --guest, so if neither --host nor --guest
>> +  is input, the perf data file name is perf.data.guest. If --host is input,
>> +  the perf data file name is perf.data.kvm. If you want to record data into
>> +  perf.data.host, please input --host --no-guest. The behaviors are shown as
>> +  following:
> Perhaps this is clearer:
>
> "Use 'perf kvm record <command>' to record the a profile of an arbitrary
> workload and save it into a perf.data file. The default is to record
> guest samples, use --host to ask for just host samples or both --guest
> and --host for both kinds of samples to be taken."
>
> Argh, then I wonder why do we have --guest if the only possibility,
> according to the text above, is for it to be used in the --no-guest
> variant, is that the case?
>
> Do we really, really need to have those .host or .guest or .kvm filename
> suffixes?
>
> Can't we have this somehow encoded in the perf.data file header and show
> it when doing a report? humm, it is already, and we can see it already
> in 'perf evlist':
>
> [root@ssdandy ~]# perf kvm record -a
> ^C[ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 1.489 MB perf.data.guest (~65058 samples) ]
> [root@ssdandy ~]# perf evlist
> raw_syscalls:sys_enter
> raw_syscalls:sys_exit
> [root@ssdandy ~]# perf evlist -v
> raw_syscalls:sys_enter: sample_freq=1, type: 2, config: 41, size: 96,
> sample_type: IP|TID|TIME|CALLCHAIN|ID|CPU|PERIOD|RAW, read_format: ID,
> disabled: 1, inherit: 1, mmap: 1, comm: 1, enable_on_exec: 1,
> sample_id_all: 1, exclude_guest: 1
> raw_syscalls:sys_exit: sample_freq=1, type: 2, config: 40, size: 96,
> sample_type: IP|TID|TIME|CALLCHAIN|ID|CPU|PERIOD|RAW, read_format: ID,
> disabled: 1, inherit: 1, enable_on_exec: 1, sample_id_all: 1,
> exclude_guest: 1
> [root@ssdandy ~]#
>
> Humm, strange, the exclude_guest bit is set, which doesn't look like it
> matches that text...
>
> Lemme try explicitely using --guest and --host:
>
> [root@ssdandy ~]# perf kvm --guest record sleep 2
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.012 MB perf.data.guest (~532 samples) ]
> [root@ssdandy ~]# perf evlist -v
> raw_syscalls:sys_enter: sample_freq=1, type: 2, config: 41, size: 96, sample_type: IP|TID|TIME|CALLCHAIN|ID|CPU|PERIOD|RAW, read_format: ID, disabled: 1, inherit: 1, mmap: 1, comm: 1, enable_on_exec: 1, sample_id_all: 1, exclude_guest: 1
> raw_syscalls:sys_exit: sample_freq=1, type: 2, config: 40, size: 96, sample_type: IP|TID|TIME|CALLCHAIN|ID|CPU|PERIOD|RAW, read_format: ID, disabled: 1, inherit: 1, enable_on_exec: 1, sample_id_all: 1, exclude_guest: 1
> [root@ssdandy ~]#
>
> exclude_guest still there...
>
> Then:
>
> [root@ssdandy ~]# perf kvm --host record sleep 2
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.012 MB perf.data.kvm (~544 samples) ]
> [root@ssdandy ~]# perf evlist -v
> raw_syscalls:sys_enter: sample_freq=1, type: 2, config: 41, size: 96, sample_type: IP|TID|TIME|CALLCHAIN|ID|CPU|PERIOD|RAW, read_format: ID, disabled: 1, inherit: 1, mmap: 1, comm: 1, enable_on_exec: 1, sample_id_all: 1, exclude_guest: 1
> raw_syscalls:sys_exit: sample_freq=1, type: 2, config: 40, size: 96, sample_type: IP|TID|TIME|CALLCHAIN|ID|CPU|PERIOD|RAW, read_format: ID, disabled: 1, inherit: 1, enable_on_exec: 1, sample_id_all: 1, exclude_guest: 1
> [root@ssdandy ~]#
>
> Still there... oops, I've been just bitten by this odd suffixes convention,
> as 'perf evlist', like all other tools, by default will look at 'perf.data', not
> the 'perf kvm' convention...
...
>
> So again:
>
> [root@ssdandy ~]# perf kvm --guest record -a
> ^C[ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 1.060 MB perf.data.guest (~46303 samples) ]
> [root@ssdandy ~]# ls -lart perf.data* | tail -1
> -rw-------. 1 root root 1113684 Dec  4 11:11 perf.data.guest
> [root@ssdandy ~]# perf evlist -v -i perf.data.guest
> cycles: sample_freq=4000, size: 96, sample_type: IP|TID|TIME|CPU|PERIOD, disabled: 1, inherit: 1, mmap: 1, comm: 1, freq: 1, sample_id_all: 1, exclude_host: 1
> [root@ssdandy ~]#
>
> Matches the documentation, i.e. perf_event_attr.exclude_guest is not set,
> meaning --guest, and .exclude_host is set, ok.
>
> [root@ssdandy ~]# perf kvm --host record sleep 1
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.013 MB perf.data.kvm (~554 samples) ]
> [root@ssdandy ~]# ls -lart perf.data* | tail -1
> -rw-------. 1 root root   15976 Dec  4 11:13 perf.data.kvm
> [root@ssdandy ~]# perf evlist -v -i perf.data.kvm
> cycles: sample_freq=4000, size: 96, sample_type: IP|TID|TIME|PERIOD, disabled: 1, inherit: 1, mmap: 1, comm: 1, freq: 1, enable_on_exec: 1, sample_id_all: 1
> [root@ssdandy ~]#
>
> Yes, 'perf kvm record --host' actually means: "perf kvm --host --guest', as
> both exclude_{host,guest} are zeroed.
>
> [root@ssdandy ~]# perf kvm --host --no-guest record sleep 1
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.013 MB perf.data.host (~552 samples) ]
> [root@ssdandy ~]# ls -lart perf.data* | tail -1
> -rw-------. 1 root root   15904 Dec  4 11:14 perf.data.host
> [root@ssdandy ~]# perf evlist -v -i perf.data.host
> cycles: sample_freq=4000, size: 96, sample_type: IP|TID|TIME|PERIOD, disabled: 1, inherit: 1, mmap: 1, comm: 1, freq: 1, enable_on_exec: 1, sample_id_all: 1, exclude_guest: 1
> [root@ssdandy ~]#
>
> Seems all ok, just not immediately intuitive.

Okey, thanx for your verification. More detail will be added in my 
patches in future.
>
> I would expect one to do: (yeah, there was a discussion long ago, can't
> remember the details right now, should have paid more attention at the
> time :-\)
>
> perf kvm record <target>
>
> to mean:
>
> perf kvm record --host --guest <target>
Do you mean we should change the default behavior of perf kvm to --host 
and --guest?

Hmmm, IMHO, --guest is used more frequently.
>
> and generate a perf.data file, just like all other tools.

Yes, just using perf.data is good to me.
> What about 'perf kvm report', I think one will have to point it to the
> right file to use, using -i, right?

Currently, it will check the perf_guest and perf_host to decide perf 
data file name if
we did not use -i for it, same with perf kvm record.
> So doing it at 'perf kvm record'
> explicitely as well will reduce confusion and make it behave just like
> all the other tools?
>
> Comments?

Arnaldo, I think the problem here is that do we really need the suffixes 
for perf kvm.
Maybe your discussion long ago can make this problem more clear :).

- Yang
> - Arnaldo
>
>> +    Default('')         ->  perf.data.guest
>> +    --host              ->  perf.data.kvm
>> +    --guest             ->  perf.data.guest
>> +    --host --guest      ->  perf.data.kvm
>> +    --host --no-guest   ->  perf.data.host
>>   
>>     'perf kvm report' to display the performance counter profile information
>>     recorded via perf kvm record.
>> -- 
>> 1.8.2.1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

