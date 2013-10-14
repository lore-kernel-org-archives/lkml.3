Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab3JNO5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 10:57:47 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:34881 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841Ab3JNO5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 10:57:46 -0400
Date: Mon, 14 Oct 2013 11:57:38 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Chenggang Qin <chenggang.qin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Chenggang Qin <chenggang.qcg@taobao.com>,
        David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] perf tools: avoid traverse dsos list while find vdso
Message-ID: <20131014145738.GC11175@ghostprotocols.net>
References: <1378732916-3537-1-git-send-email-chenggang.qin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378732916-3537-1-git-send-email-chenggang.qin@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Sep 09, 2013 at 09:21:55PM +0800, Chenggang Qin escreveu:
> From: Chenggang Qin <chenggang.qcg@taobao.com>
> 
> Vdso is only one in a system. It is not necessory to traverse the
> macine->user_dsos list when looking for the dso of vdso.
> The flag vdso_found should be replaced by a pointor that point to the dso of
> vdso. If the pointer is NULL, dso of vdso have not been created. Else, the
> pointor can be returned directly in function vdso__dso_findnew().
> The list traversing can be avoided by this method.
> Thanks.
> 
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Cc: Namhyung Kim <namhyung@gmail.com>
> Cc: Yanmin Zhang <yanmin.zhang@intel.com>
> Cc: Wu Fengguang <fengguang.wu@intel.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Chenggang Qin <chenggang.qcg@taobao.com>
> 
> ---
>  tools/perf/util/vdso.c |   22 ++++++++--------------
>  1 files changed, 8 insertions(+), 14 deletions(-)
> 
> diff --git a/tools/perf/util/vdso.c b/tools/perf/util/vdso.c
> index 3915982..8022ef0 100644
> --- a/tools/perf/util/vdso.c
> +++ b/tools/perf/util/vdso.c
> @@ -13,7 +13,7 @@
>  #include "symbol.h"
>  #include "linux/string.h"
>  
> -static bool vdso_found;
> +static struct dso *vdso_dso = NULL;
>  static char vdso_file[] = "/tmp/perf-vdso.so-XXXXXX";
>  
>  static int find_vdso_map(void **start, void **end)
> @@ -55,9 +55,6 @@ static char *get_file(void)
>  	size_t size;
>  	int fd;
>  
> -	if (vdso_found)
> -		return vdso_file;
> -
>  	if (find_vdso_map(&start, &end))
>  		return NULL;
>  
> @@ -79,33 +76,30 @@ static char *get_file(void)
>   out:
>  	free(buf);
>  
> -	vdso_found = (vdso != NULL);
>  	return vdso;
>  }
>  
>  void vdso__exit(void)
>  {
> -	if (vdso_found)
> +	if (vdso_dso)
>  		unlink(vdso_file);

Don't we have to delete the vfso_dso and set it to NULL?

>  }
>  
>  struct dso *vdso__dso_findnew(struct list_head *head)
>  {
> -	struct dso *dso = dsos__find(head, VDSO__MAP_NAME, true);
> -
> -	if (!dso) {
> +	if (!vdso_dso) {
>  		char *file;
>  
>  		file = get_file();
>  		if (!file)
>  			return NULL;
>  
> -		dso = dso__new(VDSO__MAP_NAME);
> -		if (dso != NULL) {
> -			dsos__add(head, dso);
> -			dso__set_long_name(dso, file);
> +		vdso_dso = dso__new(VDSO__MAP_NAME);
> +		if (vdso_dso != NULL) {
> +			dsos__add(head, vdso_dso);
> +			dso__set_long_name(vdso_dso, file);
>  		}
>  	}
>  
> -	return dso;
> +	return vdso_dso;
>  }
> -- 
> 1.7.8.rc2.5.g815b
