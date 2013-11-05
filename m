Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab3KECXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 21:23:54 -0500
Received: from intranet.asianux.com ([58.214.24.6]:40360 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab3KECXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 21:23:53 -0500
X-Spam-Score: -100.8
Message-ID: <52785676.8030801@asianux.com>
Date: Tue, 05 Nov 2013 10:22:46 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Chen Gang F T <chen.gang.flying.transformer@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] get_maintainer: Improve "Author:" rolestats
References: <52738E90.6040104@asianux.com>  <1383330777.3042.2.camel@joe-AO722> <52750739.6040706@gmail.com> <1383602096.28651.8.camel@joe-AO722>
In-Reply-To: <1383602096.28651.8.camel@joe-AO722>
Content-Type: multipart/mixed;
 boundary="------------020801000706040303000008"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020801000706040303000008
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/05/2013 05:54 AM, Joe Perches wrote:
> Add this to "try this"...
> 
> Chen Gang's defect is because his git repository branch
> had a commit he authored but where did not add his signature.
> 

Hmm... for pure next-20131101 tree in my git directory and the demo
patches in attachment, it will cause this issue.

And excuse me, I am not quite familiar with git, could you provide more
details (e.g. where the special difference of the demo patches or the
pure next-20131101 tree in my git directory)? thanks.

> Also, there's a defect in function vcs_find_signers.
> It should only return the commit count and array references.
> 
> If there are no signers in the commit history interval specified,
> then the "authors" array is added to the "signers" array and
> returned as a single array.
> 
> Use references instead.
> 
> Make sure that references are defined in the places
> that vcs_find_signers is called.
> 

After apply the patch below, it can work well.

Tested-by Chen Gang <gang.chen@asianux.com>



> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  scripts/get_maintainer.pl | 21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
> index ee9adb8..9c3986f 100755
> --- a/scripts/get_maintainer.pl
> +++ b/scripts/get_maintainer.pl
> @@ -128,7 +128,7 @@ my %VCS_cmds_git = (
>      "blame_commit_pattern" => "^([0-9a-f]+) ",
>      "author_pattern" => "^GitAuthor: (.*)",
>      "subject_pattern" => "^GitSubject: (.*)",
> -    "stat_pattern" => "(\\d+)\\t(\\d+)\\t\$file",
> +    "stat_pattern" => "^(\\d+)\\t(\\d+)\\t\$file\$",
>  );
>  
>  my %VCS_cmds_hg = (
> @@ -156,7 +156,7 @@ my %VCS_cmds_hg = (
>      "blame_commit_pattern" => "^([ 0-9a-f]+):",
>      "author_pattern" => "^HgAuthor: (.*)",
>      "subject_pattern" => "^HgSubject: (.*)",
> -    "stat_pattern" => "(\\d+)\t(\\d+)\t\$file",
> +    "stat_pattern" => "^(\\d+)\t(\\d+)\t\$file\$",
>  );
>  
>  my $conf = which_conf(".get_maintainer.conf");
> @@ -1297,7 +1297,7 @@ sub vcs_find_signers {
>  
>  #    print("stats: <@stats>\n");
>  
> -    return (0, @signatures, @authors) if !@signatures;
> +    return (0, \@signatures, \@authors, \@stats) if !@signatures;
>  
>      save_commits_by_author(@lines) if ($interactive);
>      save_commits_by_signer(@lines) if ($interactive);
> @@ -1880,9 +1880,10 @@ sub vcs_file_signoffs {
>      $cmd =~ s/(\$\w+)/$1/eeg;		# interpolate $cmd
>  
>      ($commits, $signers_ref, $authors_ref, $stats_ref) = vcs_find_signers($cmd, $file);
> -    @signers = @{$signers_ref};
> -    @authors = @{$authors_ref};
> -    @stats = @{$stats_ref};
> +
> +    @signers = @{$signers_ref} if defined $signers_ref;
> +    @authors = @{$authors_ref} if defined $authors_ref;
> +    @stats = @{$stats_ref} if defined $stats_ref;
>  
>  #    print("commits: <$commits>\nsigners:<@signers>\nauthors: <@authors>\nstats: <@stats>\n");
>  
> @@ -1965,8 +1966,8 @@ sub vcs_file_blame {
>  	    $cmd =~ s/(\$\w+)/$1/eeg;	#substitute variables in $cmd
>  
>  	    ($commit_count, $commit_signers_ref, $commit_authors_ref, $stats_ref) = vcs_find_signers($cmd, $file);
> -	    @commit_authors = @{$commit_authors_ref};
> -	    @commit_signers = @{$commit_signers_ref};
> +	    @commit_authors = @{$commit_authors_ref} if defined $commit_authors_ref;
> +	    @commit_signers = @{$commit_signers_ref} if defined $commit_signers_ref;
>  
>  	    push(@signers, @commit_signers);
>  	} else {
> @@ -1983,8 +1984,8 @@ sub vcs_file_blame {
>  		$cmd =~ s/(\$\w+)/$1/eeg;	#substitute variables in $cmd
>  
>  		($commit_count, $commit_signers_ref, $commit_authors_ref, $stats_ref) = vcs_find_signers($cmd, $file);
> -		@commit_authors = @{$commit_authors_ref};
> -		@commit_signers = @{$commit_signers_ref};
> +		@commit_authors = @{$commit_authors_ref} if defined $commit_authors_ref;
> +		@commit_signers = @{$commit_signers_ref} if defined $commit_signers_ref;
>  
>  		push(@signers, @commit_signers);
>  	    }
> 
> 
> 
> 


-- 
Chen Gang

--------------020801000706040303000008
Content-Type: text/x-patch;
 name="1.unused.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="1.unused.patch"

Subject: [PATCH] hexagon: kernel: remove useless variables 'dn', 'r' and 'err' in time_init_deferred() in "time.c"
Date: Fri, 01 Nov 2013 19:07:48 +0800
From: Chen Gang <gang.chen@asianux.com>

Remove them, since they are useless. The related warnings (with
allmodconfig for v4):

    CC      arch/hexagon/kernel/time.o
  arch/hexagon/kernel/time.c: In function 'time_init_deferred':
  arch/hexagon/kernel/time.c:196: warning: unused variable 'err'
  arch/hexagon/kernel/time.c:195: warning: unused variable 'r'
  arch/hexagon/kernel/time.c:194: warning: unused variable 'dn'


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/hexagon/kernel/time.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/hexagon/kernel/time.c b/arch/hexagon/kernel/time.c
index 9903fad..d0c4f5a 100644
--- a/arch/hexagon/kernel/time.c
+++ b/arch/hexagon/kernel/time.c
@@ -191,9 +191,6 @@ void __init time_init_deferred(void)
 {
 	struct resource *resource = NULL;
 	struct clock_event_device *ce_dev = &hexagon_clockevent_dev;
-	struct device_node *dn;
-	struct resource r;
-	int err;
 
 	ce_dev->cpumask = cpu_all_mask;
 
-- 
1.7.7.6




--------------020801000706040303000008
Content-Type: text/x-patch;
 name="4.kgdb_extend.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="4.kgdb_extend.patch"



-------- Original Message --------
Subject: [PATCH] hexagon: include: asm: kgdb: extend DBG_MAX_REG_NUM for "cs0/1"
Date: Fri, 01 Nov 2013 19:55:38 +0800
From: Chen Gang <gang.chen@asianux.com>
To: Richard Kuo <rkuo@codeaurora.org>
CC: linux-hexagon@vger.kernel.org

Need extend maximized number for "cs0/1", the related warning (with
allmodconfig for v4):

  arch/hexagon/kernel/kgdb.c:79: warning: excess elements in array initializer
  arch/hexagon/kernel/kgdb.c:79: warning: (near initialization for 'dbg_reg_def')
  arch/hexagon/kernel/kgdb.c:80: warning: excess elements in array initializer
  arch/hexagon/kernel/kgdb.c:80: warning: (near initialization for 'dbg_reg_def')


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/hexagon/include/asm/kgdb.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/hexagon/include/asm/kgdb.h b/arch/hexagon/include/asm/kgdb.h
index 32a6fb6..ccd3ac3 100644
--- a/arch/hexagon/include/asm/kgdb.h
+++ b/arch/hexagon/include/asm/kgdb.h
@@ -34,10 +34,11 @@ static inline void arch_kgdb_breakpoint(void)
  * 32 gpr + sa0/1 + lc0/1 + m0/1 + gp + ugp + pred + pc = 42 total.
  * vm regs = psp+elr+est+badva = 4
  * syscall+restart = 2 more
- * so 48 = 42 +4 + 2
+ * also add cs0/1 = 2
+ * so 48 = 42 + 4 + 2 + 2
  */
 #define DBG_USER_REGS 42
-#define DBG_MAX_REG_NUM (DBG_USER_REGS + 6)
+#define DBG_MAX_REG_NUM (DBG_USER_REGS + 8)
 #define NUMREGBYTES  (DBG_MAX_REG_NUM*4)
 
 #endif /* __HEXAGON_KGDB_H__ */
-- 
1.7.7.6




--------------020801000706040303000008--
