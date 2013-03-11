Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab3CKV5h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:57:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47177 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab3CKV5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:57:36 -0400
Date: Mon, 11 Mar 2013 14:57:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Raphael S. Carvalho" <raphael.scarv@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] kernel/pid.c: Improve flow of a loop inside
 alloc_pidmap.
Message-Id: <20130311145734.b7a068a782e787facd285a80@linux-foundation.org>
In-Reply-To: <1363036736-14209-1-git-send-email-raphael.scarv@gmail.com>
References: <1363036736-14209-1-git-send-email-raphael.scarv@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Mar 2013 18:18:56 -0300 "Raphael S. Carvalho" <raphael.scarv@gmail.com> wrote:

> From: Raphael S.Carvalho <raphael.scarv@gmail.com>
> 
> Notes: find_next_offset searches for an available "cleaned bit"
> in the respective pid bitmap (page), so returns the offset if found,
> otherwise it returns a value equals to BITS_PER_PAGE.
> 
> For example, suppose find_next_offset didn't find any available
> bit, so there's no purpose to call mk_pid (Wasteful Cpu Cycles).
> 
> Therefore, I found it could be better to call mk_pid after
> the checking (offset < BITS_PER_PAGE) returned sucessfully!
> Another point: If (offset < BITS_PER_PAGE) results in a "failure",
> then mk_pid would be called again afterwards.
> 
> ...
>
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -190,8 +190,8 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
>  					return pid;
>  				}
>  				offset = find_next_offset(map, offset);
> -				pid = mk_pid(pid_ns, map, offset);
> -			} while (offset < BITS_PER_PAGE && pid < pid_max);
> +			} while (offset < BITS_PER_PAGE && 
> +				(pid = mk_pid(pid_ns, map, offset)) < pid_max);
>  		}
>  		if (map < &pid_ns->pidmap[(pid_max-1)/BITS_PER_PAGE]) {
>  			++map;

Looks OK.  But I think it's simpler and more straightforward to do it
this way?

			for ( ; ; ) {
				if (!test_and_set_bit(offset, map->page)) {
					atomic_dec(&map->nr_free);
					set_last_pid(pid_ns, last, pid);
					return pid;
				}
				offset = find_next_offset(map, offset);
				if (offset >= BITS_PER_PAGE)
					break;
				pid = mk_pid(pid_ns, map, offset);
				if (pid >= pid_max)
					break;
			}

