Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435Ab3K1PbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 10:31:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045Ab3K1PbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 10:31:03 -0500
Date: Thu, 28 Nov 2013 16:30:31 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 7/7] perf inject: Handle output file via perf_data_file
 object
Message-ID: <20131128153031.GA31444@krava.brq.redhat.com>
References: <1385634619-8129-1-git-send-email-jolsa@redhat.com>
 <1385634619-8129-8-git-send-email-jolsa@redhat.com>
 <20131128141435.GC3603@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128141435.GC3603@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 12:14:35PM -0200, Arnaldo Carvalho de Melo wrote:
> Em Thu, Nov 28, 2013 at 11:30:19AM +0100, Jiri Olsa escreveu:
> > Using the perf_data_file object to handle output
> > file processing.
> > 
> > No functional change intended.
> 
> There is one, before we were using:
> 
> -		inject.output = open(output_name, O_CREAT | O_WRONLY | O_TRUNC,
> -						  S_IRUSR | S_IWUSR);
> 
> And 
> 
> +	if (perf_data_file__open(&inject.output)) {
> 
> Does:
> 
>           return open(file->path, O_CREAT|O_RDWR|O_TRUNC, S_IRUSR|S_IWUSR);
> 
> Why do we need to do O_RDWR there? Can we live with plain O_WRONLY as
> before?

I think the reason is the record's buildid's hunt
during the exit.. we read the file we just stored
without reopening it for reading

hum, how about the output file mmapping David is working on,
that might need file to be readable as well..

> 
> Also, while reviewing this I got something that I missed in previous
> patches, I think we could reuse:
> 
>   O_WRONLY to replace the long constant PERF_DATA_MODE_WRITE
>   O_RDONLY ditto -> PERF_DATA_MODE_READ
> 
> Shorter, and matches what we need here: a open flag value to specify
> which access mode the perf.data file is operating, no?

I guess that would work.. but I planned for future more
perf specific flags like PERF_DATA_MODE_DIR or something
like that.. I haven't this fully thought through yet..

jirka
