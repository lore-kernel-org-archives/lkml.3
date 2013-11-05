Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab3KENHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 08:07:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754795Ab3KENHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 08:07:48 -0500
Date: Tue, 5 Nov 2013 14:07:29 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/3] perf tools: Factor sysfs code into generic fs object
Message-ID: <20131105130729.GD1071@krava.brq.redhat.com>
References: <1383563173-17466-1-git-send-email-jolsa@redhat.com>
 <1383563173-17466-2-git-send-email-jolsa@redhat.com>
 <20131105124814.GA5539@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131105124814.GA5539@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 10:48:14AM -0200, Arnaldo Carvalho de Melo wrote:

SNIP

> > +struct perf_fs {
> 
> Ditch the 'perf', make it plain 'struct fs'.
> 
> > +	const char		*name;
> > +	const char * const	*mounts;
> > +	char			 path[PATH_MAX + 1];
> > +	bool			 found;
> > +	long			 magic;
> > +};
> > +
> > +enum {
> > +	FS_SYSFS = 0,
> 
> FS__SYSFS
> 
> > +};
> > +
> > +static struct perf_fs fss[] = {
> 
> Funny name, perhaps fs__entries instead? :-)

ok, will change all above namings :)

> 
> And here we have it static, at some point we could introduce a
> 'fs__register', that would be the counterpart of 'register_filesystem'
> in the kernel sources.
> 
> > +	[FS_SYSFS] = {
> > +		.name	= "sysfs",
> > +		.mounts	= sysfs_known_mountpoints,
> > +		.magic	= SYSFS_MAGIC,
> > +	},
> > +};
> > +
> > +static bool read_mounts(struct perf_fs *fs)
> > +{
> > +	bool found = false;
> > +	char type[100];
> > +	FILE *fp;
> > +
> > +	fp = fopen("/proc/mounts", "r");
> > +	if (fp == NULL)
> > +		return NULL;
> > +
> > +	while (!found &&
> > +	       fscanf(fp, "%*s %" STR(PATH_MAX) "s %99s %*s %*d %*d\n",
> > +		      fs->path, type) == 2) {
> > +
> > +		if (strcmp(type, fs->name) == 0)
> > +			found = true;
> > +	}
> > +
> > +	fclose(fp);
> > +	return fs->found = found;
> > +}
> 
> This is not a per instance method, I to traverse /proc/mounts once,
> checking all entries in 'fs__entries' marking the ones that are present,
> i.e. fs__entries would be a list/tree of 'struct fs'.
> 
> > +static int valid_mount(const char *fs, long magic)
> > +{
> > +	struct statfs st_fs;
> > +
> > +	if (statfs(fs, &st_fs) < 0)
> > +		return -ENOENT;
> > +	else if (st_fs.f_type != magic)
> > +		return -ENOENT;
> > +
> > +	return 0;
> > +}
> 
> Now this is getting me confused, so we will have to traverse
> /proc/mounts looking  for that .name to be what we expect in entries and
> afterwards we do a second step, checking if the magic number is the one
> expected? Can't we do both verifications in just one place?

the valid_mount is called only for preconfigured
(known mountpoints) paths

> 
> I know you haven't written this code, is just generalizing, but I got
> confused so had to comment on it :-\

yep ;-) perhaps some init code could do that

> 
> Perhaps since you're just making it useful for more filesystems just
> please address the 'perf_fs' naming suggestions and we can deal with
> these other issues later?

ok, I have already changes for the 3/3 change,
I'll send it together

jirka
