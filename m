Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab3KDQH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 11:07:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab3KDQH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 11:07:58 -0500
Date: Mon, 4 Nov 2013 17:09:14 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 11/13] tracing/kprobes: Add priv argument to fetch
	functions
Message-ID: <20131104160914.GA8595@redhat.com>
References: <1383029621-7384-1-git-send-email-namhyung@kernel.org> <1383029621-7384-12-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383029621-7384-12-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See my replies to 0/13. Lets assume that you agree that get_user_vaddr()
doesn't need tu->inode.

On 10/29, Namhyung Kim wrote:
>
> This argument is for passing private data structure to each fetch
> function and will be used by uprobes.

In this case, why do we need this "void *priv"? It actually becomes
"bool need_addr_translation".

Can't we avoid it? Can't we just add FETCH_MTD_memory_notranslate ?
kprobes should use the same methods for FETCH_MTD_memory*, uprobes
should obviously adjust the addr in FETCH_MTD_memory.

Then (afaics) we need a single change in parse_probe_arg(),

	-	dprm->fetch = t->fetch[FETCH_MTD_memory];
	+	dprm->fetch = t->fetch[FETCH_MTD_memory_notranslate];

Yes, this will blow *probes_fetch_type_table[], but looks simpler.

And. This way it would be simple to teach parse_probe_arg('@') to use
_notranslate, say, "@=addr" or whatever.

Oleg.

