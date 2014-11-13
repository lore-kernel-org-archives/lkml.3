Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934115AbaKMUIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 15:08:40 -0500
Received: from mail.kernel.org ([198.145.19.201]:58828 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933383AbaKMUIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 15:08:39 -0500
Date: Thu, 13 Nov 2014 17:08:33 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: jolsa@redhat.com, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 02/10] perf, tools: Support handling complete branch
 stacks as histograms
Message-ID: <20141113200833.GI3612@kernel.org>
References: <1415844328-4884-1-git-send-email-andi@firstfloor.org>
 <1415844328-4884-3-git-send-email-andi@firstfloor.org>
 <20141113191417.GC3612@kernel.org>
 <20141113195208.GS12538@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141113195208.GS12538@two.firstfloor.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Nov 13, 2014 at 08:52:08PM +0100, Andi Kleen escreveu:
> On Thu, Nov 13, 2014 at 04:14:17PM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Wed, Nov 12, 2014 at 06:05:20PM -0800, Andi Kleen escreveu:
> > > +static int remove_loops(struct branch_entry *l, int nr)
> > > +{
> > > +	int i, j, off;
> > > +	unsigned char chash[CHASHSZ];
> > > +
> > > +	memset(chash, NO_ENTRY, sizeof(chash));
> > > +
> > > +	BUG_ON(nr >= 256);
> > 
> > What is wrong with return -1 and propagating the error, so that the user
> > is informed if the data being processed is bogus, stop processing with a
> > warning or continue processing if finding the next valid record is
> > possible?
> 
> The error doesn't depend on the record. There is a check for the record
> being < 127 in front of this. This is merely to catch that 
> if someone increases PERF_MAX_BRANCH_DEPTH to below 255 they need
> to increase the type of the hash table from u8.

Ok, so this would be better as a BUILD_BUG_ON? 

Like:

#define CHASHSZ 127
#define CHASHBITS 7
#define NO_ENTRY 0xff

#define PERF_MAX_BRANCH_DEPTH 127

/* Remove loops. */
static int remove_loops(struct branch_entry *l, int nr)
{
	int i, j, off;
	unsigned char chash[CHASHSZ];

	memset(chash, NO_ENTRY, sizeof(chash));

	/* Change the type of the chash table, u8 is not enough now */
	BUILD_BUG_ON(PERF_MAX_BRANCH_DEPTH >= 256);
	for (i = 0; i < nr; i++) {
		int h = hash_64(l[i].from, CHASHBITS) % CHASHSZ;

-------------------------------------

- Arnaldo
