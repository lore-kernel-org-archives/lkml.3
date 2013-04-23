Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab3DWB2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 21:28:09 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:48677 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564Ab3DWB2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 21:28:07 -0400
X-Greylist: delayed 56899 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Apr 2013 21:28:07 EDT
X-AuditID: 85900ec0-d56cbb900000151e-2b-5175e3a49880
Message-ID: <5175E39F.4020706@hitachi.com>
Date: Tue, 23 Apr 2013 10:27:59 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: Re: [PATCH V2 1/3] trace-cmd: Define general functions for
 outputting/inputting saved_cmdlines
References: <20130422094306.26615.70754.stgit@yunodevel>  <20130422094309.26615.46676.stgit@yunodevel> <1366661205.9609.133.camel@gandalf.local.home>
In-Reply-To: <1366661205.9609.133.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

(2013/04/23 5:06), Steven Rostedt wrote:
> On Mon, 2013-04-22 at 18:43 +0900, Yoshihiro YUNOMAE wrote:
>> Currently, trace-cmd outputs data of saved_cmdlines to a trace.dat file
>> in create_file_fd() and inputs the data from the file in tracecmd_init_data().
>> On the other hand, trace-cmd will also output and input data of trace_clock in
>> those functions in the patch "trace-cmd: Add recording to trace_clock" and
>> "Add support for extracting trace_clock in report".
>>
>> The source code of the output/input of saved_cmdlines data can be reused when
>> extract trace_clock, so we define general functions for outputting/inputting a
>> file on debugfs.
>>
>> Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
>> ---
>>   trace-input.c  |   46 +++++++++++++++++++++++++++++-------------
>>   trace-output.c |   62 ++++++++++++++++++++++++++++++++------------------------
>>   2 files changed, 67 insertions(+), 41 deletions(-)
>>
>> diff --git a/trace-input.c b/trace-input.c
>> index 56a8e8d..232015a 100644
>> --- a/trace-input.c
>> +++ b/trace-input.c
>> @@ -1870,6 +1870,37 @@ static int read_cpu_data(struct tracecmd_input *handle)
>>
>>   }
>>
>> +static int read_data_and_size(struct tracecmd_input *handle,
>> +				     char **data, unsigned long long *size)
>> +{
>> +	*size = read8(handle);
>> +	if (*size < 0)
>> +		return -1;
>> +	*data = malloc(*size + 1);
>> +	if (!*data)
>> +		return -1;
>> +	if (do_read_check(handle, *data, *size)) {
>> +		free(*data);
>> +		return -1;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int read_and_parse_cmdlines(struct tracecmd_input *handle,
>> +							struct pevent *pevent)
>> +{
>> +	unsigned long long size;
>> +	char *cmdlines;
>> +
>> +	if (read_data_and_size(handle, &cmdlines, &size) < 0)
>> +		return -1;
>> +	cmdlines[size] = 0;
>> +	parse_cmdlines(pevent, cmdlines, size);
>> +	free(cmdlines);
>> +	return 0;
>> +}
>> +
>>   /**
>>    * tracecmd_init_data - prepare reading the data from trace.dat
>>    * @handle: input handle for the trace.dat file
>> @@ -1880,23 +1911,10 @@ static int read_cpu_data(struct tracecmd_input *handle)
>>   int tracecmd_init_data(struct tracecmd_input *handle)
>>   {
>>   	struct pevent *pevent = handle->pevent;
>> -	unsigned long long size;
>> -	char *cmdlines;
>>   	int ret;
>>
>> -	size = read8(handle);
>> -	if (size < 0)
>> -		return -1;
>> -	cmdlines = malloc(size + 1);
>> -	if (!cmdlines)
>> +	if (read_and_parse_cmdlines(handle, pevent) < 0)
>>   		return -1;
>> -	if (do_read_check(handle, cmdlines, size)) {
>> -		free(cmdlines);
>> -		return -1;
>> -	}
>> -	cmdlines[size] = 0;
>> -	parse_cmdlines(pevent, cmdlines, size);
>> -	free(cmdlines);
>>
>>   	handle->cpus = read4(handle);
>>   	if (handle->cpus < 0)
>> diff --git a/trace-output.c b/trace-output.c
>> index 460b773..8697976 100644
>> --- a/trace-output.c
>> +++ b/trace-output.c
>> @@ -687,6 +687,39 @@ static int read_ftrace_printk(struct tracecmd_output *handle)
>>   	return -1;
>>   }
>>
>> +static int save_tracing_file_data(struct tracecmd_output *handle,
>> +						const char *filename)
>> +{
>> +	unsigned long long endian8;
>> +	char *file = NULL;
>> +	struct stat st;
>> +	off64_t check_size;
>> +	off64_t size;
>> +	int ret;
>> +
>> +	file = get_tracing_file(handle, filename);
>> +	ret = stat(file, &st);
>> +	if (ret >= 0) {
>> +		size = get_size(file);
>> +		endian8 = convert_endian_8(handle, size);
>> +		if (do_write_check(handle, &endian8, 8))
>> +			return -1;
>
> Can't do a return here. The "get_tracing_file()" does an allocation that
> needs to be freed with "put_tracing_file()" below. You still need the
> goto out_free, or something.

Oh, I see.
I'll send a revised patch set soon.

Thanks,
Yoshihiro YUNOMAE

> You can initialize ret = -1; and then below have:
>
>> +		check_size = copy_file(handle, file);
>> +		if (size != check_size) {
>> +			errno = EINVAL;
>> +			warning("error in size of file '%s'", file);
>> +			return -1;
>> +		}
>> +	} else {
>> +		size = 0;
>> +		endian8 = convert_endian_8(handle, size);
>> +		if (do_write_check(handle, &endian8, 8))
>> +			return -1;
>> +	}
>
> 	ret = 0;
> out_free:
>
> -- Steve
>
>> +	put_tracing_file(file);
>> +	return 0;
>> +}
>> +
>>   static struct tracecmd_output *
>>   create_file_fd(int fd, struct tracecmd_input *ihandle,
>>   	       const char *tracing_dir,

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


