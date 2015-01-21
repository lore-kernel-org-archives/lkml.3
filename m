Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbbAUVDk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 16:03:40 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:47972 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbbAUVDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 16:03:31 -0500
Message-ID: <54C01418.5060204@roeck-us.net>
Date: Wed, 21 Jan 2015 13:03:20 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Sabrina Dubroca <sd@queasysnail.net>, Paul Moore <pmoore@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-audit@redhat.com, Richard Guy Briggs <rgb@redhat.com>
Subject: Re: linux-next: Tree for Jan 20 -- Kernel panic - Unable to mount
 root fs
References: <1528536.jyty2pu4Mz@sifl> <20150121004117.GM29656@ZenIV.linux.org.uk> <54BF1292.2080902@roeck-us.net> <20150121033600.GN29656@ZenIV.linux.org.uk> <54BF2496.4000807@roeck-us.net> <20150121043637.GO29656@ZenIV.linux.org.uk> <20150121110539.GA8924@kria> <54BFAA5D.4040108@roeck-us.net> <20150121182905.GQ29656@ZenIV.linux.org.uk> <54BFF8B3.6060802@roeck-us.net> <20150121200626.GR29656@ZenIV.linux.org.uk>
In-Reply-To: <20150121200626.GR29656@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Suspect
X-CTCH-VOD: Unknown
X-CTCH-Flags: 512
X-CTCH-RefID: str=0001.0A020203.54C01422.00D3,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=512,sb=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 4
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 4
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2015 12:06 PM, Al Viro wrote:
> On Wed, Jan 21, 2015 at 11:06:27AM -0800, Guenter Roeck wrote:
>> On 01/21/2015 10:29 AM, Al Viro wrote:
>>> On Wed, Jan 21, 2015 at 05:32:13AM -0800, Guenter Roeck wrote:
>>>> Another data point (though I have no idea if it is useful or what it means):
>>>>
>>>> In the working case, path_init sets nd->flags to 0x50 or 0x51.
>>>> In the non-working case (ie for all files with a '/' in the name),
>>>> it sets nd->flags to 0x10 or 0x11, even though it is always called
>>>> with the LOOKUP_RCU bit set in flags.
>>>
>>> Umm...  Are those path_init() succeeding or failing?  Note that path_init()
>>> includes "walk everything except for the last component", so your non-working
>>> case is "have it walk anything at all".  What's failing there?  path_init()
>>> or handling the remaining component?
>>>
>> path_init() returns -2. Guess that explains the unexpected flags ;-).
>> The failuere is from
>> 	link_path_walk()
>> 		walk_component()
>
> Which is to say, lookup gave it a negative dentry.  OK, let's just make
> vfs_mkdir() and walk_component() print what they are doing; on top of
> linux-next
>
> diff --git a/fs/namei.c b/fs/namei.c
> index 323957f..8a4e22f 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -1586,8 +1586,11 @@ static inline int walk_component(struct nameidata *nd, struct path *path,
>   		inode = path->dentry->d_inode;
>   	}
>   	err = -ENOENT;
> -	if (!inode || d_is_negative(path->dentry))
> +	if (!inode || d_is_negative(path->dentry)) {
> +		printk(KERN_ERR "walk_component[%p,%pd4] -> negative\n",
> +			path->dentry, path->dentry);
>   		goto out_path_put;
> +	}
>
>   	if (should_follow_link(path->dentry, follow)) {
>   		if (nd->flags & LOOKUP_RCU) {
> @@ -3521,6 +3524,7 @@ int vfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
>   	error = dir->i_op->mkdir(dir, dentry, mode);
>   	if (!error)
>   		fsnotify_mkdir(dir, dentry);
> +	printk(KERN_ERR "mkdir[%p,%pd4] => %d\n", dentry, dentry, error);
>   	return error;
>   }
>   EXPORT_SYMBOL(vfs_mkdir);
>

ok case (putname commented out):

user_path_at_empty lookup usr flags 0x0
path_lookupat: calling path_init 'usr' flags=40
path_init: link_path_walk() returned 0
path_lookupat: path_init 'usr' flags=40[50] returned 0
walk_component: lookup_fast() returned 1
walk_component: lookup_slow() returned 0
walk_component: inode=  (null), negative=1
do_path_lookup(usr, 0x10)
path_lookupat: calling path_init 'usr' flags=50
path_init: link_path_walk() returned 0
path_lookupat: path_init 'usr' flags=50[50] returned 0
mkdir[c74012a0,/usr] => 0
user_path_at_empty lookup usr flags 0x1
path_lookupat: calling path_init 'usr' flags=41
path_init: link_path_walk() returned 0
path_lookupat: path_init 'usr' flags=41[51] returned 0
walk_component: inode=c74004a0, negative=0
user_path_at_empty lookup usr flags 0x1
path_lookupat: calling path_init 'usr' flags=41
path_init: link_path_walk() returned 0
path_lookupat: path_init 'usr' flags=41[51] returned 0

failing case:

path_lookupat: calling path_init 'usr' flags=40
path_init: link_path_walk() returned 0
path_lookupat: path_init 'usr' flags=40[50] returned 0
walk_component: lookup_fast() returned 1
walk_component: lookup_slow() returned 0
walk_component: inode=  (null), negative=1
do_path_lookup(usr, 0x10)
path_lookupat: calling path_init 'usr' flags=50
path_init: link_path_walk() returned 0
path_lookupat: path_init 'usr' flags=50[50] returned 0
mkdir[c74012a0,/kkk] => 0						<==== SIC!
user_path_at_empty lookup usr flags 0x1
path_lookupat: calling path_init 'usr' flags=41
path_init: link_path_walk() returned 0
path_lookupat: path_init 'usr' flags=41[51] returned 0
walk_component: lookup_fast() returned 1
walk_component: lookup_slow() returned 0
walk_component: inode=  (null), negative=1
user_path_at_empty lookup usr flags 0x1
path_lookupat: calling path_init 'usr' flags=41
path_init: link_path_walk() returned 0
path_lookupat: path_init 'usr' flags=41[51] returned 0
walk_component: lookup_fast() returned 1
walk_component: lookup_slow() returned 0
walk_component: inode=  (null), negative=1

Guenter



