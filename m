Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab3KUVQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 16:16:32 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:33657 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab3KUVQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 16:16:29 -0500
Message-ID: <528E782A.9010509@gmail.com>
Date: Thu, 21 Nov 2013 14:16:26 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, mingo@kernel.org
CC: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] perf util: optimize util/machine.c:machines__find().
References: <1385069470-22692-1-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1385069470-22692-1-git-send-email-yangds.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/13, 2:31 PM, Dongsheng Yang wrote:
> * Remove an unnecessary variable default_machine.
> * Return earlier to avoid unnecessary searching in children.
>
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> ---
>   tools/perf/util/machine.c | 11 +++++------
>   1 file changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index 84cdb07..f0dd5f6 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -175,8 +175,7 @@ struct machine *machines__find(struct machines *machines, pid_t pid)
>   {
>   	struct rb_node **p = &machines->guests.rb_node;
>   	struct rb_node *parent = NULL;
> -	struct machine *machine;
> -	struct machine *default_machine = NULL;
> +	struct machine *machine = NULL;
>
>   	if (pid == HOST_KERNEL_ID)
>   		return &machines->host;
> @@ -184,17 +183,17 @@ struct machine *machines__find(struct machines *machines, pid_t pid)
>   	while (*p != NULL) {
>   		parent = *p;
>   		machine = rb_entry(parent, struct machine, rb_node);
> +		if (!machine->pid)
> +			break;
>   		if (pid < machine->pid)
>   			p = &(*p)->rb_left;
>   		else if (pid > machine->pid)
>   			p = &(*p)->rb_right;
>   		else
> -			return machine;
> -		if (!machine->pid)
> -			default_machine = machine;
> +			break;
>   	}
>
> -	return default_machine;
> +	return machine;
>   }

This changes machines__find to always return the machine for the host 
(pid == 0). This function is also used for VM lookups.

David

