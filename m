Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab3KECiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 21:38:21 -0500
Received: from intranet.asianux.com ([58.214.24.6]:12969 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab3KECiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 21:38:20 -0500
X-Spam-Score: -100.8
Message-ID: <527859D9.30109@asianux.com>
Date: Tue, 05 Nov 2013 10:37:13 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Chen Gang F T <chen.gang.flying.transformer@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] get_maintainer: Improve "Author:" rolestats
References: <52738E90.6040104@asianux.com>  <1383330777.3042.2.camel@joe-AO722> <52750739.6040706@gmail.com> <1383602096.28651.8.camel@joe-AO722> <52785676.8030801@asianux.com>
In-Reply-To: <52785676.8030801@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2013 10:22 AM, Chen Gang wrote:
> On 11/05/2013 05:54 AM, Joe Perches wrote:
>> Add this to "try this"...
>>
>> Chen Gang's defect is because his git repository branch
>> had a commit he authored but where did not add his signature.
>>

Hmm... in fact, when I make a patch, I really let "git log" contents a
commit I author but where do not add my  signature.

But after I let it pure next-20131101 ("git reset HEAD^; git stash"), it
still cause this issue.

> 
> Hmm... for pure next-20131101 tree in my git directory and the demo
> patches in attachment, it will cause this issue.
> 
> And excuse me, I am not quite familiar with git, could you provide more
> details (e.g. where the special difference of the demo patches or the
> pure next-20131101 tree in my git directory)? thanks.
> 
>> Also, there's a defect in function vcs_find_signers.
>> It should only return the commit count and array references.
>>
>> If there are no signers in the commit history interval specified,
>> then the "authors" array is added to the "signers" array and
>> returned as a single array.
>>
>> Use references instead.
>>
>> Make sure that references are defined in the places
>> that vcs_find_signers is called.
>>
> 
> After apply the patch below, it can work well.
> 
> Tested-by Chen Gang <gang.chen@asianux.com>
> 
> 
> 
>> Signed-off-by: Joe Perches <joe@perches.com>
>> ---
>>  scripts/get_maintainer.pl | 21 +++++++++++----------
>>  1 file changed, 11 insertions(+), 10 deletions(-)
>>
>> diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
>> index ee9adb8..9c3986f 100755
>> --- a/scripts/get_maintainer.pl
>> +++ b/scripts/get_maintainer.pl
>> @@ -128,7 +128,7 @@ my %VCS_cmds_git = (
>>      "blame_commit_pattern" => "^([0-9a-f]+) ",
>>      "author_pattern" => "^GitAuthor: (.*)",
>>      "subject_pattern" => "^GitSubject: (.*)",
>> -    "stat_pattern" => "(\\d+)\\t(\\d+)\\t\$file",
>> +    "stat_pattern" => "^(\\d+)\\t(\\d+)\\t\$file\$",
>>  );
>>  
>>  my %VCS_cmds_hg = (
>> @@ -156,7 +156,7 @@ my %VCS_cmds_hg = (
>>      "blame_commit_pattern" => "^([ 0-9a-f]+):",
>>      "author_pattern" => "^HgAuthor: (.*)",
>>      "subject_pattern" => "^HgSubject: (.*)",
>> -    "stat_pattern" => "(\\d+)\t(\\d+)\t\$file",
>> +    "stat_pattern" => "^(\\d+)\t(\\d+)\t\$file\$",
>>  );
>>  
>>  my $conf = which_conf(".get_maintainer.conf");
>> @@ -1297,7 +1297,7 @@ sub vcs_find_signers {
>>  
>>  #    print("stats: <@stats>\n");
>>  
>> -    return (0, @signatures, @authors) if !@signatures;
>> +    return (0, \@signatures, \@authors, \@stats) if !@signatures;
>>  
>>      save_commits_by_author(@lines) if ($interactive);
>>      save_commits_by_signer(@lines) if ($interactive);
>> @@ -1880,9 +1880,10 @@ sub vcs_file_signoffs {
>>      $cmd =~ s/(\$\w+)/$1/eeg;		# interpolate $cmd
>>  
>>      ($commits, $signers_ref, $authors_ref, $stats_ref) = vcs_find_signers($cmd, $file);
>> -    @signers = @{$signers_ref};
>> -    @authors = @{$authors_ref};
>> -    @stats = @{$stats_ref};
>> +
>> +    @signers = @{$signers_ref} if defined $signers_ref;
>> +    @authors = @{$authors_ref} if defined $authors_ref;
>> +    @stats = @{$stats_ref} if defined $stats_ref;
>>  
>>  #    print("commits: <$commits>\nsigners:<@signers>\nauthors: <@authors>\nstats: <@stats>\n");
>>  
>> @@ -1965,8 +1966,8 @@ sub vcs_file_blame {
>>  	    $cmd =~ s/(\$\w+)/$1/eeg;	#substitute variables in $cmd
>>  
>>  	    ($commit_count, $commit_signers_ref, $commit_authors_ref, $stats_ref) = vcs_find_signers($cmd, $file);
>> -	    @commit_authors = @{$commit_authors_ref};
>> -	    @commit_signers = @{$commit_signers_ref};
>> +	    @commit_authors = @{$commit_authors_ref} if defined $commit_authors_ref;
>> +	    @commit_signers = @{$commit_signers_ref} if defined $commit_signers_ref;
>>  
>>  	    push(@signers, @commit_signers);
>>  	} else {
>> @@ -1983,8 +1984,8 @@ sub vcs_file_blame {
>>  		$cmd =~ s/(\$\w+)/$1/eeg;	#substitute variables in $cmd
>>  
>>  		($commit_count, $commit_signers_ref, $commit_authors_ref, $stats_ref) = vcs_find_signers($cmd, $file);
>> -		@commit_authors = @{$commit_authors_ref};
>> -		@commit_signers = @{$commit_signers_ref};
>> +		@commit_authors = @{$commit_authors_ref} if defined $commit_authors_ref;
>> +		@commit_signers = @{$commit_signers_ref} if defined $commit_signers_ref;
>>  
>>  		push(@signers, @commit_signers);
>>  	    }
>>
>>
>>
>>
> 
> 


-- 
Chen Gang
