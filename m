Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaFDWL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 18:11:57 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:61253 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbaFDWLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 18:11:49 -0400
Message-ID: <538F99A2.2090102@gmail.com>
Date: Wed, 04 Jun 2014 16:11:46 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Revert "fib_trie: use seq_file_net rather than seq->private"
References: <1401919352-32263-1-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1401919352-32263-1-git-send-email-sasha.levin@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/4/14, 4:02 PM, Sasha Levin wrote:
> This reverts commit 30f38d2fdd79f13fc929489f7e6e517b4a4bfe63.
>
> fib_triestat is surrounded by a big lie: while it claims that it's a
> seq_file (fib_triestat_seq_open, fib_triestat_seq_show), it isn't:
>
> 	static const struct file_operations fib_triestat_fops = {
> 	        .owner  = THIS_MODULE,
> 	        .open   = fib_triestat_seq_open,
> 	        .read   = seq_read,
> 	        .llseek = seq_lseek,
> 	        .release = single_release_net,
> 	};
>
> Yes, fib_triestat is just a regular file.
>
> A small detail (assuming CONFIG_NET_NS=y) is that while for seq_files
> you could do seq_file_net() to get the net ptr, doing so for a regular
> file would be wrong and would dereference an invalid pointer.
>
> The fib_triestat lie claimed a victim, and trying to show the file would
> be bad for the kernel. This patch just reverts the issue and fixes
> fib_triestat, which still needs a rewrite to either be a seq_file or
> stop claiming it is.

It worked fine for me.

fib_triestat_seq_open() is a wrapper to single_open_net() which sets the 
namespace as the private element (returned by get_proc_net).

If CONFIG_NETNS is not set:
- single_open_net essentially sets file->private to init_net which is 
also what is returned by seq_file_net

If CONFIG_NETNS is set, all is fine.

What am I missing?

David
