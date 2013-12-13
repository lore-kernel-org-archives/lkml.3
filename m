Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab3LMEcs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 23:32:48 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:55437 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab3LMEcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 23:32:47 -0500
Message-ID: <52AA8DE8.1060901@gmail.com>
Date: Thu, 12 Dec 2013 21:32:40 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf kvm: introduce --list-cmds for use by scripts
References: <52A9E9F3.4090801@gmail.com> <1386869211-1971-1-git-send-email-artagnon@gmail.com>
In-Reply-To: <1386869211-1971-1-git-send-email-artagnon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/13, 10:26 AM, Ramkumar Ramachandra wrote:
> Introduce
>
>    $ perf kvm --list-cmds
>
> to dump a raw list of commands for use by the completion script. While
> at it, refactor kvm_usage so that there's only one copy of the command
> listing.
>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> ---
>   David Ahern wrote:
>   > That would work -- perhaps a #define or string near
>   >
>   >    const char * const kvm_usage[] = {
>   >         "perf kvm [<options>] {top|record|report|diff|buildid-list|stat}",
>   >         NULL
>   >     };
>   >
>   > Building kvm_usage from the string would better - only 1 place listing the
>   > commands.
>
>   Something like this, perhaps? It's not too pretty though: do you have
>   suggestions to prettify it?
>
>   tools/perf/builtin-kvm.c      | 25 +++++++++++++++++++++----
>   tools/perf/perf-completion.sh |  2 +-
>   2 files changed, 22 insertions(+), 5 deletions(-)
>
> diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
> index c6fa3cb..ce44a9b 100644
> --- a/tools/perf/builtin-kvm.c
> +++ b/tools/perf/builtin-kvm.c
> @@ -1672,6 +1672,7 @@ __cmd_buildid_list(const char *file_name, int argc, const char **argv)
>   int cmd_kvm(int argc, const char **argv, const char *prefix __maybe_unused)
>   {
>   	const char *file_name = NULL;
> +	bool list_cmds = false;
>   	const struct option kvm_options[] = {
>   		OPT_STRING('i', "input", &file_name, "file",
>   			   "Input file name"),
> @@ -1692,20 +1693,36 @@ int cmd_kvm(int argc, const char **argv, const char *prefix __maybe_unused)
>   			   "file", "file saving guest os /proc/modules"),
>   		OPT_INCR('v', "verbose", &verbose,
>   			    "be more verbose (show counter open errors, etc)"),
> +		OPT_BOOLEAN(0, "list-cmds", &list_cmds,
> +			"list commands raw for use by scripts"),
>   		OPT_END()
>   	};
>
> +	const char *const commands[] = { "top", "record", "report", "diff",
> +					 "buildid-list", "stat", NULL };

Building it is kind of ugly looking.

Arnaldo: what about this:
#define KVM_CMDS  "top record report diff buildid-list stat"

> +	char kvm_usage_str[80];
> +	const char *kvm_usage[] = { NULL, NULL };
>
> -	const char * const kvm_usage[] = {
> -		"perf kvm [<options>] {top|record|report|diff|buildid-list|stat}",
> -		NULL

	const char * const kvm_usage[] = {
		"perf kvm [<options>] <command>, command = " KVM_CMDS,
		NULL

I would even be fine with not touching kvm_usage and having the KVM_CMDS 
macro right above it -- changing one causes the other to show up in a diff.


David

