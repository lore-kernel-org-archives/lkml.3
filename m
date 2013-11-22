Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab3KVAGO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 19:06:14 -0500
Received: from mail-yh0-f50.google.com ([209.85.213.50]:52737 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab3KVAGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 19:06:13 -0500
Date: Thu, 21 Nov 2013 21:06:08 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf util: optimize util/machine.c:machines__find().
Message-ID: <20131122000608.GA2117@ghostprotocols.net>
References: <1385069470-22692-1-git-send-email-yangds.fnst@cn.fujitsu.com>
 <528E782A.9010509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528E782A.9010509@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Nov 21, 2013 at 02:16:26PM -0700, David Ahern escreveu:
> On 11/21/13, 2:31 PM, Dongsheng Yang wrote:
> >* Remove an unnecessary variable default_machine.
> >* Return earlier to avoid unnecessary searching in children.

> >Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

> >+++ b/tools/perf/util/machine.c
> >@@ -175,8 +175,7 @@ struct machine *machines__find(struct machines *machines, pid_t pid)
> >  {
> >  	struct rb_node **p = &machines->guests.rb_node;
> >  	struct rb_node *parent = NULL;
> >-	struct machine *machine;
> >-	struct machine *default_machine = NULL;
> >+	struct machine *machine = NULL;
> >
> >  	if (pid == HOST_KERNEL_ID)
> >  		return &machines->host;
> >@@ -184,17 +183,17 @@ struct machine *machines__find(struct machines *machines, pid_t pid)
> >  	while (*p != NULL) {
> >  		parent = *p;
> >  		machine = rb_entry(parent, struct machine, rb_node);
> >+		if (!machine->pid)
> >+			break;
> >  		if (pid < machine->pid)
> >  			p = &(*p)->rb_left;
> >  		else if (pid > machine->pid)
> >  			p = &(*p)->rb_right;
> >  		else
> >-			return machine;
> >-		if (!machine->pid)
> >-			default_machine = machine;
> >+			break;
> >  	}
> >
> >-	return default_machine;
> >+	return machine;
> >  }
 
> This changes machines__find to always return the machine for the
> host (pid == 0). This function is also used for VM lookups.

Nope:

/* Native host kernel uses -1 as pid index in machine */
#define HOST_KERNEL_ID                  (-1)
#define DEFAULT_GUEST_KERNEL_ID         (0)

But I fail to see the point of the "optimization", we're looking for a
pid, not always for '0'.

And the changelog is horrible, why is it "unnecessary"? Please don't be
so terse :-)

- Arnaldo
