Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbaIPXle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 19:41:34 -0400
Received: from jambon.ath.cx ([212.129.4.85]:38528 "EHLO jambon.ath.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186AbaIPXlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 19:41:32 -0400
Date: Wed, 17 Sep 2014 01:41:30 +0200
From: Junien Fridrick <linux.kernel@junien.fridrick.net>
To: Aleksei Besogonov <alex.besogonov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Run a script with cap_net_bind_service - mission impossible.
Message-ID: <20140916234130.GA12369@jambon.ath.cx>
References: <loom.20140915T145605-849@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <loom.20140915T145605-849@post.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 01:07:03PM +0000, Aleksei Besogonov wrote:
> Hi!

Hi,

> 
> It seems that it's totally impossible to start a script with
> cap_net_bind_service capability and as a non-root user without modifying
> system-wide settings.
> 
> I've trawled the Net for a solution that should be exceedingly simple. I
> want to run a daemon under a non-privileged account AND allow it to bind to
> 'secure' ports (443, 589 and 53). So far I found the following non-solutions:
> 
> - Use iptables to redirect ports. Doesn't work with local traffic.

Unless I'm missing something, you can use iptables to redirect ports even for
local traffic : you need to use the OUTPUT chain. For example, if I run :
# iptables -t nat -I OUTPUT -p tcp -d 192.168.0.1 --dport 1245 -j REDIRECT --to-port 1246

and then from the same machine, run :
$ nc -v 192.168.0.1 1245

The connection will be redirected to port 1246. Doesn't that answer your use
case ?

> - Use an HTTP proxy server (yeah, and also a DNS proxy server).
> - Set cap_net_bind_service capability bit on the script interpreter (so
> it'll break during upgrades). 
> - Fuck you, run it under the root user. With several permutations like:
>   * Dropping caps after opening sockets (can't do this)
>   * Dropping all caps before starting the interpreter (fucks up the file
> ownership)
> 
> I've tried without any luck various permutations of capsh like: capsh
> --keep=1 --secbits=5 --user=cyberax --caps=cap_net_bind_service+eip -- -c
> 'nc -l 443'
> 
> So is it possible at all?
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
