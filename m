Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab3CCTMJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 14:12:09 -0500
Received: from nm17.access.bullet.mail.mud.yahoo.com ([66.94.237.218]:43976
	"EHLO nm17.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753346Ab3CCTMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 14:12:07 -0500
X-Yahoo-Newman-Id: 132188.55972.bm@smtp104.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: .olmNmcVM1leGfBjngehk4CDwK5Gyr9MaTEa5zr52zRA9Nx
 8IDAgY5AT0oOTGvDT8rXJgrTXsjmwNaGN9QwU3dj6916sYiPnSi0XXqBlHVY
 QkAbZPvNVH53fagGKQcX6jkWCiSI23sA_.q0.L7kFM9usX7ExsIafwnzRyT.
 Lh_Bmv_FcF.7OscGLcdZaLetQ6Y1ME_y0zfvzqlShDWbO5.yQvuevmB4JBHX
 k1Rt.E3sK4UJuxZ6bWXbGyvjnrZZ_KfzZCspoWFOT01Krbwf0sj1WC2eFCwa
 Apaf0RHBNy6162UfMArzFjQW9KW_QY30sSNBElrKqAoD_7pO.US3l4T4tmw8
 58zk.6o8TPB8qOPqRen3LL3gJITWbVbL01CBooMFWhjeB2fcOV2lvkj3La1w
 35e9NNnUOgQ3EYwWBFpGcilXtXGQCV8XydI2zSAOMrqdIxnClYzhZFB.BgXy
 5CHkmib0mYLnjrg--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <5133A084.2060304@schaufler-ca.com>
Date: Sun, 03 Mar 2013 11:12:04 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Steven Whitehouse <swhiteho@redhat.com>
CC: Mimi Zohar <zohar@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: security_inode_init_security() inode field requirements
References: <1362132778.2723.15.camel@menhir>
In-Reply-To: <1362132778.2723.15.camel@menhir>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/1/2013 2:12 AM, Steven Whitehouse wrote:
> Hi,
>
> I'm wondering whether there is a list somewhere of fields which
> security_inode_init_security() requires are set in an inode when it is
> called? In particular, does it matter if the inode number itself is
> unset when security_inode_init_security() is called?
>
> The problem that I'm looking at is the use of multiple transactions
> during inode creation when some combination of ACLs/LSMs/IMA are turned
> on. What we have currently (in GFS2, there are other fs which follow
> broadly the same solution though) is this:
>
> 1. Create inode in core
> 2. Create inode on disk
> 3. Add xattrs one at a time for ACLs/LSMs/IMA
> 4. Link inode into directory
>
> Steps 2 through 4 require separate transactions at the moment. What I'd
> like to do is to be able to get the details of the xattrs ahead of time
> such that the allocation of the inode can be one and the same allocation
> as that for the xattr blocks. That allows merging of the transactions
> into one and a greatly simplified error path too. This would look
> something like:
>
> 1. Create in-core inode and init required fields
> 2. Get details of all xattrs for the inode

Although none of the existing LSMs do so, you have to allow for
the case where an LSM uses multiple labels or lists of labels,
or makes decisions based on the order in which inodes are processed.
As Mimi points out, the details of the attributes may depend on
the state of initialization.

> 3. Alloc on disk inode and blocks for xattrs as needed
> 4. Link into directory
>
> In this case, steps 2 through 4 are within a single transaction. We
> don't actually need to have the content of the xattrs ahead of
> allocating the inode, just the length (or even just a max length, if it
> is not too large). However the easiest solution would just be to move
> the call to security_inode_init_security() to the point before we've
> allocated the inode (and thus we don't know its number yet) but after
> we've filled out all the remaining fields if that makes sense?
>
> So I just wanted to check whether that would break anything,
>
> Steve.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

