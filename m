Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbaAWOnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 09:43:35 -0500
Received: from mail-yk0-f175.google.com ([209.85.160.175]:55859 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845AbaAWOnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 09:43:33 -0500
X-Greylist: delayed 6188 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Jan 2014 09:43:33 EST
Date: Thu, 23 Jan 2014 11:43:24 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, yrl.pp-manager.tt@hitachi.com,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH -tip 2/8] [BUGFIX] perf-tools: Load map before using
 map->map_ip
Message-ID: <20140123144324.GB17572@ghostprotocols.net>
References: <20140123022945.7206.79944.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
 <20140123022950.7206.17357.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140123022950.7206.17357.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jan 23, 2014 at 02:29:50AM +0000, Masami Hiramatsu escreveu:
> In map_groups__find_symbol() map->map_ip is used without
> ensuring the map is loaded. Then the address passed
> to map->map_ip isn't mapped at the first time.
> 
> E.g. below code always fails to get a symbol at the first call;
> 
> 	addr = /* Somewhere in the kernel text */
> 	symbol_conf.try_vmlinux_path = true;
> 	symbol__init();
> 	host_machine = machine__new_host();
> 	sym = machine__find_kernel_function(host_machine,
> 					 addr, NULL, NULL);
> 	/* Note that machine__find_kernel_function calls
> 	   map_groups__find_symbol */
> 
> This ensures it by calling map__load before using it in
> map_groups__find_symbol().

Good catch! map__find_symbol() will load it if necessary, but that is
after map->map_ip() is called.

Applying.

- Arnaldo
 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> ---
>  tools/perf/util/map.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
> index 9b9bd71..6a805e7 100644
> --- a/tools/perf/util/map.c
> +++ b/tools/perf/util/map.c
> @@ -386,7 +386,8 @@ struct symbol *map_groups__find_symbol(struct map_groups *mg,
>  {
>  	struct map *map = map_groups__find(mg, type, addr);
>  
> -	if (map != NULL) {
> +	/* Ensure map is loaded before using map->map_ip */
> +	if (map != NULL && map__load(map, filter) >= 0) {
>  		if (mapp != NULL)
>  			*mapp = map;
>  		return map__find_symbol(map, map->map_ip(map, addr), filter);
> 
