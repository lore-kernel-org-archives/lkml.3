Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835Ab3HTT2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 15:28:51 -0400
Received: from relay3.sgi.com ([192.48.152.1]:42535 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751611Ab3HTT2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 15:28:49 -0400
Date: Tue, 20 Aug 2013 14:28:44 -0500
From: Ben Myers <bpm@sgi.com>
To: Dwight Engen <dwight.engen@oracle.com>, Jeremy Kerr <jk@ozlabs.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, cbe-oss-dev@lists.ozlabs.org,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
        linux-next@vger.kernel.org, Gao feng <gaofeng@cn.fujitsu.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: linux-next: build failure after merge of the final tree
Message-ID: <20130820192844.GC5262@sgi.com>
References: <20130820172052.1f0d89ddf6a1a40ef70333fd@canb.auug.org.au>
 <20130820120702.000b044e@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820120702.000b044e@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeremy,

Apologies for breaking your build...

On Tue, Aug 20, 2013 at 12:07:02PM -0400, Dwight Engen wrote:
> On Tue, 20 Aug 2013 17:20:52 +1000
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > After merging the final tree, today's linux-next build (powerpc
> > allyesconfig) failed like this:
> > 
> > arch/powerpc/platforms/cell/spufs/inode.c: In function
> > 'spufs_parse_options':
> > arch/powerpc/platforms/cell/spufs/inode.c:623:16: error: incompatible
> > types when assigning to type 'kuid_t' from type 'int' root->i_uid =
> > option; ^ arch/powerpc/platforms/cell/spufs/inode.c:628:16: error:
> > incompatible types when assigning to type 'kgid_t' from type 'int'
> > root->i_gid = option; ^
> > 
> > Caused by commit d6970d4b726c ("enable building user namespace with
> > xfs") from the xfs tree (that was fun to find :-)).
> > 
> > I have reverted that commit for today.  It could probably be replaced
> > with a patch that just changed XFS_FS to SPU_FS in the
> > UIDGID_CONVERTED config dependency - or someone could fix up SPU_FS.
> 
> Hi, (already sent this email based on Intel's kbuild robot this
> morning, sorry for the dup to those who already got it). 
> 
> Yep this looks to me like SPU_FS should have been in the list of
> stuff that had not been UIDGID_CONVERTED, but reviving
> UIDGID_CONVERTED and adding SPU_FS to it won't work for
> non powerpc arch because SPU_FS = n won't be defined. The following can
> be used to mark it as incompatible with USER_NS:
> 
> diff --git a/arch/powerpc/platforms/cell/Kconfig
> b/arch/powerpc/platforms/cell/Kconfig index 9978f59..fcf8336 100644
> --- a/arch/powerpc/platforms/cell/Kconfig
> +++ b/arch/powerpc/platforms/cell/Kconfig
> @@ -61,6 +61,7 @@ config SPU_FS
>         tristate "SPU file system"
>         default m
>         depends on PPC_CELL
> +       depends on USER_NS=n
>         select SPU_BASE
>         select MEMORY_HOTPLUG
>         help
> 
> Or if the rest of spufs is already okay for user namespace (I have not
> checked it, but this seems to be the only place it is dealing with
> uid/gid), then the following will fix these particular errors
> (cross-compile tested, but I don't have a powerpc to run test on):
> 
> diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
> index f390042..90fb308 100644
> --- a/arch/powerpc/platforms/cell/spufs/inode.c
> +++ b/arch/powerpc/platforms/cell/spufs/inode.c
> @@ -620,12 +620,12 @@ spufs_parse_options(struct super_block *sb, char *options, struct inode *root)
>                 case Opt_uid:
>                         if (match_int(&args[0], &option))
>                                 return 0;
> -                       root->i_uid = option;
> +                       root->i_uid = make_kuid(&init_user_ns, option);
>                         break;
>                 case Opt_gid:
>                         if (match_int(&args[0], &option))
>                                 return 0;
> -                       root->i_gid = option;
> +                       root->i_gid = make_kgid(&init_user_ns, option);
>                         break;
>                 case Opt_mode:
>                         if (match_octal(&args[0], &option))

I'd prefer not to break Stephen's tree two days in a row.  We could just revert
d6970d4b726c in the xfs tree for the time being as Stephen has done, but given
the choice would prefer the fix.  Do you have a preference between the two
approaches that Dwight has posted?  The first seems more conservative...

Thanks,
	Ben
