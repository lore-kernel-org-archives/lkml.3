Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab3KAAQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 20:16:43 -0400
Received: from mail12.copyleft.no ([188.94.218.224]:46706 "EHLO
	mail12.copyleft.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471Ab3KAAQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 20:16:41 -0400
MIME-Version: 1.0
In-Reply-To: <xmqqa9hp9x2e.fsf@gitster.dls.corp.google.com>
References: <20131024122255.GI9378@mwanda>
	<20131024122512.GB9534@mwanda>
	<20131026181709.GB10488@kroah.com>
	<20131027013402.GA7146@leaf>
	<526CA7D4.1070904@alum.mit.edu>
	<20131027071407.GA11683@leaf>
	<526E283A.1070801@alum.mit.edu>
	<CALKQrgfsk3fjyF77XL9+CPyJ_s-AfzkNAj4Eaj1LT-G0Ph=bfg@mail.gmail.com>
	<20131029020824.GE11861@sigill.intra.peff.net>
	<CALKQrge8T8R7roUUYyLcu_QnL1afeqTATOp+0n_OOsZZoJXF4Q@mail.gmail.com>
	<CACsJy8DVSpmmDw-jGJoJK171u5UeJR7GKPuX7QAK4=7yYn6n8Q@mail.gmail.com>
	<xmqqa9hp9x2e.fsf@gitster.dls.corp.google.com>
Date: Fri, 1 Nov 2013 01:16:33 +0100
Message-ID: <CALKQrgcTA6cODDMOwX_hNwsfKU-+X-rhgf0U9SVYqg7bpMAthA@mail.gmail.com>
Subject: Re: [PATCH] commit: Add -f, --fixes <commit> option to add Fixes: line
From: Johan Herland <johan@herland.net>
To: Junio C Hamano <gitster@pobox.com>
Cc: Duy Nguyen <pclouds@gmail.com>, Jeff King <peff@peff.net>,
        Michael Haggerty <mhagger@alum.mit.edu>,
        Josh Triplett <josh@joshtriplett.org>,
        Git mailing list <git@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, Greg KH <greg@kroah.com>,
        Linux Kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 6:20 PM, Junio C Hamano <gitster@pobox.com> wrote:
> Duy Nguyen <pclouds@gmail.com> writes:
>> OK how about, if $GIT_DIR/hooks/something is a directory, then the
>> directory must contain a file named "index", listing all the hooks of
>> type "something". All the hooks in "index" will be executed in the
>> listing order.
>
> Hooks that take arbitrary amount of information from the body read
> their standard input. How are your multiple hooks supposed to
> interact?

As an example, at $dayjob we have a "dispatcher" post-receive hook
running on our Git server that captures the current environment, and
reads all of stdin. It then iterates through a (configurable) sequence
of "subhooks" providing them each with a copy of the data that was
passed to it. The "subhooks" may perform duties such as notifying
automated build and test systems, triggering updates of mirrors,
updating bug trackers, formatting and sending commit emails to mailing
lists, etc. Some of them are run synchronously (redirecting their
output back to the push client), and some are run asynchronously
(redirecting their output to logs). The nice thing is that each of the
"subhooks" use the same post-receive hook interface, and is therefore
a fully capable stand-alone hook by itself (often implemented in
different languages, some of them are not even written by us), and
also fully independent of the other "subhooks". It is therefore
relatively straightforward to add, remove and mix hooks.

> Hooks that prevent you from doing something stupid signal allow/deny
> with their exit code. Do you fail a commit if any of your pre-commit
> hook fails, or is it OK to commit as long as one of them says so?
> If the former, do all the hooks described in the index still run, or
> does the first failure short-cut the remainder?

This clearly needs to be configurable, as there are valid use cases
for all the behaviors you mention. That said, I believe that a sane
default would be for a single hook failure to cause the entire
chain-of-hooks to fail, including short-cutting the remainder of the
hooks (at least for the hooks where the exit code determines the
outcome of the entire operation). For example, one could envision a
sequence of pre-commit hooks being configured something like this:

  [hook "pre-commit.check-whitespace"]
          run = /path/to/whitespace-checker
          on-error = fail-later
  [hook "pre-commit.check-valid-ident"]
          run = /path/to/ident-checker
          on-error = fail-later
  [hook "pre-commit.run-testsuite"]
          run = "/path/to/testsuite --with --arguments"
          on-error = fail-later

The hooks would be run in sequence. The hook.pre-commit.*.run variable
specifies how to execute the hook (it is assumed that each of the
configured hooks behaves according to the pre-commit hook interface).
The hook.pre-commit.*.on-error variable specifies how to handle a
non-zero exit code from the hook. Possible values would be "abort"
(abort the remaining hooks and return failure immediately),
"fail-later" (keep running the remainder of the hooks, but make sure
we do return failure in the end), or "ignore" (always pretend the hook
returns successfully). The default on-error behavior should IMHO be
"abort", but in this case, we don't want to abort on the first
failure, as we'd rather report errors from _multiple_ hooks to the
user in a single go.

Similarly, a sequence of post-receive hooks could be configure like this:

  [hook "post-receive.trigger-buildbot"]
          run = /path/to/buildbot-trigger-hook
  [hook "post-receive.update-bugtracker"]
          run = /path/to/bugtracker-update-hook
  [hook "post-receive.trigger-mirror-update"]
          run = /path/to/mirror-update-hook
          async = true
          redirect-output = /var/log/mirror-update-hook.log
  [hook "post-receive.send-commit-emails"]
          run = /path/to/commit-emailer
          async = true

Here, the .on-error variable is probably less than useful, since
post-receive hooks cannot affect the outcome of the push operation
(and having one post-receive hook abort the running of another is
probably uncommon). Instead, the .async variable (default: false) is
used to indicate which hooks should be run asynchronously (i.e. the
client does not have to wait for these hooks to complete).

On a server with many repos, you could even store the above in the
global git config, to have the hooks available to all repos, and then
use hook.post-receive.*.enabled = true/false to turn hooks on/off for
individual repos.

(A nice side-effect of putting this stuff in the config is that it
makes is easy to add/remove/manage hooks through our Gitolite setup -
which already has support for managing per-repo config options in the
Gitolite config.)

This is just some initial thoughts about a possible config format. A
more important point though, is that we don't really need to add
anything to core Git to support this. All we need to do is to
implement a set of "dispatcher" hooks that read the relevant
configuration and perform the job accordingly.

Although these "dispatcher" hooks could certainly be developed as a
separate project - more or less independent from git.git, I do believe
there would be considerable value in distributing them along with Git
and easily enabling them (maybe even enabling them by default, as
without the config options they would just be no-ops). Otherwise, it
would be hard to make them used/accepted widely enough to actually
replace current ad hoc solutions.


...Johan

-- 
Johan Herland, <johan@herland.net>
www.herland.net
