Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbaIPQPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 12:15:22 -0400
Received: from mailsec108.isp.belgacom.be ([195.238.20.104]:9329 "EHLO
	mailsec108.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753895AbaIPQPU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:15:20 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=UGN7JNw3bPEHpwjh5ACRRBK85/3fvewMg9DN/Z6sboU= c=1 sm=2
 a=XryuEu0TkPcA:10 a=qeYcf6Gh41QA:10 a=IkcTkHD0fZMA:10 a=IJv9LcIfAAAA:8
 a=XruPTiYFmJm7p6oLz6MA:9 a=QEXdDO2ut3YA:10 a=K6kUPx8HyhEA:10
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8LAH9hGFTD7hTU/2dsb2JhbABggw1TV4J8sQUBAQEBAQEGlxWHVgGBFBYBeYQDAQEBAwEjVgULBQQCFwECAhgOAgJPCAYTEYglDIkinEWGf48HAReBLIRQiRwzB4J4gVMFlgSIZZNlg2A7L4JKAQEB
Date: Tue, 16 Sep 2014 18:15:18 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Message-ID: <1685749151.185639.1410884118738.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <1410837769.18787.40.camel@joe-AO725>
References: <1410806637-3510-1-git-send-email-fabf@skynet.be> <1410837769.18787.40.camel@joe-AO725>
Subject: Re: [PATCH 1/1] checkpatch: check for subject uniqueness in git
 repository.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.2.2-Rev27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 16 September 2014 at 05:22 Joe Perches <joe@perches.com> wrote:
>
>
> On Mon, 2014-09-15 at 20:43 +0200, Fabian Frederick wrote:
> > Adding patch subject uniqueness check in checkpatch --strict mode.
> > See Documentation/SubmittingPatches/globally-unique identifier.
>
> Perhaps something like this?
> ---
>  scripts/checkpatch.pl | 52
>+++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 52 insertions(+)
>
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 0c520f7..e19c40b 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -622,6 +622,27 @@ sub git_commit_info {
>       return ($id, $desc);
>  }
> 
> +my @git_commits = ();
> +my @previous_subjects = ();
> +
> +sub check_subject_duplication {
> +     my ($subject) = @_;
> +
> +     if ($check && $#git_commits < 1 && which("git") && -e ".git") {
> +             my $output = `git log --no-color --format='%H %s' 2>&1`;
> +             $output =~ s/^\s*//gm;
> +             @git_commits = split("\n", $output);
> +     }
> +
> +     return 1 if (grep(/^[a-f0-9]{40,40} $subject$/, @git_commits));
> +
> +     return 2 if (grep(/^$subject$/, @previous_subjects));
> +
> +     push(@previous_subjects, $subject);
> +
> +     return 0;
> +}
> +
>  $chk_signoff = 0 if ($file);
> 
>  my @rawlines = ();
> @@ -1264,6 +1285,20 @@ sub raw_line {
>       return $line;
>  }
> 
> +sub get_complete_header {
> +     my ($linenr) = @_;
> +
> +     my $offset = $linenr - 1;
> +
> +     my $line = $rawlines[$offset++];
> +     while (defined $rawlines[$offset] &&
> +            $rawlines[$offset] =~ /\s(\S.*)$/) {
> +             $line .= $rawlines[$offset++];
> +     }
> +
> +     return $line;
> +}
> +
>  sub cat_vet {
>       my ($vet) = @_;
>       my ($res, $coded);
> @@ -2047,6 +2082,23 @@ sub process {
>                       }
>               }
> 
> +# Check git commit and patch subject duplication
> +             if ($in_header_lines && $line =~ /^Subject:/) {
> +                     my $subject = get_complete_header($linenr);
> +                     if ($subject =~ /^Subject:\s*(?:\[[^\]]*\])?\s*(.*)$/) {
> +                             $subject = $1;
> +                     }
> +
> +                     my $subject_dup = check_subject_duplication($subject);
> +                     if ($subject_dup == 1) {
> +                             CHK("NOT_UNIQUE_SUBJECT",
> +                                 "Identical git commit subject found\n" .
> $herecurr);
> +                     } elsif ($subject_dup == 2) {
> +                             CHK("NOT_UNIQUE_SUBJECT",
> +                                 "Identical patch commit subject found\n" .
> $herecurr);
> +                     }
> +             }
> +
>  # Check the patch for a signoff:
>               if ($line =~ /^\s*signed-off-by:/i) {
>                       $signoff++;
>
>
Perfect ! :)
