Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab3HZBsU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 21:48:20 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:60025 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857Ab3HZBsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 21:48:19 -0400
X-AuditID: 85900ec0-d1d29b9000001514-ff-521ab3e0c7f0
Message-ID: <521AB3DF.3070505@hitachi.com>
Date: Mon, 26 Aug 2013 10:48:15 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: Re: [RFC PATCH 07/11] [CLEANUP] trace-cmd: Split out binding
 a port and fork reader from open_udp()
References: <20130819094620.26597.79499.stgit@yunodevel> <20130819094637.26597.35505.stgit@yunodevel> <20130820134902.3a06e4d0@gandalf.local.home>
In-Reply-To: <20130820134902.3a06e4d0@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/08/21 2:49), Steven Rostedt wrote:
> On Mon, 19 Aug 2013 18:46:37 +0900
> Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:
>
>> Split out binding a port and fork reader from open_udp() for avoiding duplicate
>> codes between listen mode and virt-server mode.
>>
>> Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
>> ---
>>   trace-listen.c |   34 ++++++++++++++++++++++++++--------
>>   1 file changed, 26 insertions(+), 8 deletions(-)
>>
>> diff --git a/trace-listen.c b/trace-listen.c
>> index f29dd35..bf9ef9d 100644
>> --- a/trace-listen.c
>> +++ b/trace-listen.c
>> @@ -228,13 +228,12 @@ static void process_udp_child(int sfd, const char *host, const char *port,
>>   #define START_PORT_SEARCH 1500
>>   #define MAX_PORT_SEARCH 6000
>>
>> -static int open_udp(const char *node, const char *port, int *pid,
>> -		    int cpu, int pagesize, int start_port)
>> +static int udp_bind_a_port(int start_port, int *sfd)
>>   {
>>   	struct addrinfo hints;
>>   	struct addrinfo *result, *rp;
>> -	int sfd, s;
>>   	char buf[BUFSIZ];
>> +	int s;
>>   	int num_port = start_port;
>>
>>    again:
>> @@ -250,15 +249,15 @@ static int open_udp(const char *node, const char *port, int *pid,
>>   		pdie("getaddrinfo: error opening udp socket");
>>
>>   	for (rp = result; rp != NULL; rp = rp->ai_next) {
>> -		sfd = socket(rp->ai_family, rp->ai_socktype,
>> -			     rp->ai_protocol);
>> -		if (sfd < 0)
>> +		*sfd = socket(rp->ai_family, rp->ai_socktype,
>> +			      rp->ai_protocol);
>> +		if (*sfd < 0)
>>   			continue;
>>
>> -		if (bind(sfd, rp->ai_addr, rp->ai_addrlen) == 0)
>> +		if (bind(*sfd, rp->ai_addr, rp->ai_addrlen) == 0)
>>   			break;
>>
>> -		close(sfd);
>> +		close(*sfd);
>>   	}
>>
>>   	if (rp == NULL) {
>> @@ -270,6 +269,12 @@ static int open_udp(const char *node, const char *port, int *pid,
>>
>>   	freeaddrinfo(result);
>>
>> +	return num_port;
>> +}
>> +
>> +static void fork_udp_reader(int sfd, const char *node, const char *port,
>> +			    int *pid, int cpu, int pagesize)
>> +{
>>   	*pid = fork();
>>
>>   	if (*pid < 0)
>> @@ -279,6 +284,19 @@ static int open_udp(const char *node, const char *port, int *pid,
>>   		process_udp_child(sfd, node, port, cpu, pagesize);
>>
>>   	close(sfd);
>> +}
>> +
>> +static int open_udp(const char *node, const char *port, int *pid,
>> +		    int cpu, int pagesize, int start_port)
>> +{
>> +	int sfd;
>> +	int num_port;
>> +
>> +	num_port = udp_bind_a_port(start_port, &sfd);
>> +	if (num_port < 0)
>> +		return num_port;
>
> I don't see how num_port could be less than zero.

I think so, but trace-cmd checks whether udp_port is less than zero or
not in create_all_readers().

May I submit the removal patch?

Thanks,
Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


