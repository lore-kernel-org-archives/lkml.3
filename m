Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab3JVIzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 04:55:41 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:51964 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab3JVIzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 04:55:40 -0400
X-AuditID: 85900ec0-d1328b9000001514-4f-52663d8a39a1
Message-ID: <52663D93.1060507@hitachi.com>
Date: Tue, 22 Oct 2013 17:55:47 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH V2 4/5] trace-cmd: Add virt-server mode for a virtualization
 environment
References: <20130913020627.28927.69090.stgit@yunodevel> <20130913020637.28927.43185.stgit@yunodevel> <20131017223237.3acac97d@gandalf.local.home>
In-Reply-To: <20131017223237.3acac97d@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/10/18 11:32), Steven Rostedt wrote:
> On Fri, 13 Sep 2013 11:06:37 +0900
> Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:
>
>>   static int *create_all_readers(int cpus, const char *node, const char *port,
>> -			       int pagesize, int fd)
>> +			       const char *domain, int virtpid, int pagesize, int fd)
>>   {
>>   	char buf[BUFSIZ];
>> -	int *port_array;
>> +	int *port_array = NULL;
>>   	int *pid_array;
>>   	int start_port;
>>   	int udp_port;
>>   	int cpu;
>>   	int pid;
>>
>> -	port_array = malloc_or_die(sizeof(int) * cpus);
>> +	if (node) {
>> +		port_array = malloc_or_die(sizeof(int) * cpus);
>> +		start_port = START_PORT_SEARCH;
>> +	}
>>   	pid_array = malloc_or_die(sizeof(int) * cpus);
>>   	memset(pid_array, 0, sizeof(int) * cpus);
>>
>> -	start_port = START_PORT_SEARCH;
>> -
>> -	/* Now create a UDP port for each CPU */
>> +	/* Now create a reader for each CPU */
>>   	for (cpu = 0; cpu < cpus; cpu++) {
>> -		udp_port = open_udp(node, port, &pid, cpu,
>> -				    pagesize, start_port);
>> -		if (udp_port < 0)
>> -			goto out_free;
>> -		port_array[cpu] = udp_port;
>> +		if (node) {
>> +			udp_port = open_udp(node, port, &pid, cpu,
>> +					    pagesize, start_port);
>> +			if (udp_port < 0)
>> +				goto out_free;
>> +			port_array[cpu] = udp_port;
>> +			/*
>> +			 * due to some bugging finding ports,
>
> s/due/Due/

Thanks.

>> +			 * force search after last port
>> +			 */
>> +			start_port = udp_port + 1;
>> +		} else {
>> +			if (open_virtio_serial_pipe(&pid, cpu, pagesize,
>> +						    domain, virtpid) < 0)
>> +				goto out_free;
>> +		}
>>   		pid_array[cpu] = pid;
>>   		/*
>>   		 * Due to some bugging finding ports,
>
> Hmm, it seems that you added the start_port = udp_port + 1 above, but
> shouldn't you remove the one here?

Oh, you're right.
I'll delete it here.

>> @@ -482,7 +595,7 @@ static int *create_all_readers(int cpus, const char *node, const char *port,
>>   	return pid_array;
>>
>>    out_free:
>> -	destroy_all_readers(cpus, pid_array, node, port);
>> +	destroy_all_readers(cpus, pid_array, node, port, domain, virtpid);
>>   	return NULL;
>>   }
>>
>> @@ -524,7 +637,7 @@ static void stop_all_readers(int cpus, int *pid_array)
>>   }
>>
>>   static void put_together_file(int cpus, int ofd, const char *node,
>> -			      const char *port)
>> +			      const char *port, const char *domain, int virtpid)
>>   {
>>   	char **temp_files;
>>   	int cpu;
>> @@ -533,25 +646,31 @@ static void put_together_file(int cpus, int ofd, const char *node,
>>   	temp_files = malloc_or_die(sizeof(*temp_files) * cpus);
>>
>>   	for (cpu = 0; cpu < cpus; cpu++)
>> -		temp_files[cpu] = get_temp_file(node, port, cpu);
>> +		temp_files[cpu] = get_temp_file(node, port, domain,
>> +						virtpid, cpu);
>>
>>   	tracecmd_attach_cpu_data_fd(ofd, cpus, temp_files);
>>   	free(temp_files);
>>   }
>>
>> -static void process_client(const char *node, const char *port, int fd)
>> +static void process_client(const char *node, const char *port,
>> +			   const char *domain, int virtpid, int fd)
>>   {
>>   	int *pid_array;
>>   	int pagesize;
>>   	int cpus;
>>   	int ofd;
>>
>> -	if (communicate_with_client(fd, &cpus, &pagesize) < 0)
>> -		return;
>> -
>> -	ofd = create_client_file(node, port);
>> +	if (node) {
>> +		if (communicate_with_client_nw(fd, &cpus, &pagesize) < 0)
>
> I take it _nw is for "network". If so, please use "*_net" instead. "nw"
> is pretty meaningless.
>
> This applies for all functions.

OK, I'll rename all functions using _nw.

Thanks,
Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


