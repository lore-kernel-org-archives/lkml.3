Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751006AbaH1MX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 08:23:58 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:41140 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaH1MX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 08:23:57 -0400
Message-ID: <53FF1F4B.1000905@linux.vnet.ibm.com>
Date: Thu, 28 Aug 2014 17:53:39 +0530
From: Hemant Kumar <hemant@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        namhyung@kernel.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi
Subject: Re: [PATCH v4 2/3] perf/sdt : Support perf-list to print SDT events
 in a single file
References: <20140827213745.13454.46266.stgit@hemant-fedora> <20140827214426.13454.76532.stgit@hemant-fedora> <53FF0A4F.3070806@hitachi.com>
In-Reply-To: <53FF0A4F.3070806@hitachi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082812-3568-0000-0000-00000020E3AB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

On 08/28/2014 04:24 PM, Masami Hiramatsu wrote:
> (2014/08/28 6:50), Hemant Kumar wrote:
> [...]
>> +/*
>> + * get_sdt_note_info(): flush the SDT notes onto stdout
>> + */
>> +static void get_sdt_note_info(struct list_head *start, const char *target)
>> +{
>> +	struct sdt_note *pos;
>> +
>> +	if (list_empty(start))
>> +		return;
>> +
>> +	printf("%s :\n", target);
>> +	list_for_each_entry(pos, start, note_list) {
>> +		printf("%%%s : %s\n", pos->provider, pos->name);
> Hmm, this will show
>
>   %app : marker
>
> instead of
>
>   %app:marker
>
> (blanks are placed around ":")
> I think it should be the latter format.

I think so too. Missed it. Thanks for pointing that.

>> +	}
>> +}
>> +
>> +/*
>> + * Error displayed in case of query of a
>> + * single file for SDT markers
>> + */
>> +static int sdt_err(int val, const char *target)
>> +{
>> +	switch (-val) {
>> +	case 0:
>> +		break;
>> +	case ENOENT:
>> +		/* Absence of SDT markers */
>> +		printf("%s : No SDT events found\n", target);
> Please use pr_err or pr_warning for error messages.

Ah! ok.

>> +		break;
>> +	case EBADF:
>> +		printf("%s : Bad file name\n", target);
>> +		break;
>> +	default:
>> +		printf("%s\n", strerror(val));
>> +	}
> And strerror_r instead of strerror (see https://lkml.org/lkml/2014/8/13/828)

Sure, will use strerror_r instead.

>> +
>> +	return val;
>> +}
>> +
>> +/*
>> + * cleanup_sdt_note_list() : Free the sdt note list
>> + */
>> +static void cleanup_sdt_note_list(struct list_head *sdt_notes)
>> +{
>> +	struct sdt_note *tmp, *pos;
>> +
>> +	if (list_empty(sdt_notes))
>> +		return;
> You don't need to check this. If the list is empty list_for_each...
> just skips loops.

Right. Thanks for pointing that out.

>> +
>> +	list_for_each_entry_safe(pos, tmp, sdt_notes, note_list) {
>> +		list_del(&pos->note_list);
>> +		free(pos->name);
>> +		free(pos->provider);
>> +		free(pos);
>> +	}
>> +}
> Thank you,
>
>> +
>> +/*
>> + * filename__find_sdt() : looks for sdt markers and the list is
>> + * stored in sdt_notes
>> + */
>> +static int filename__find_sdt(const char *target)
>> +{
>> +	int ret;
>> +
>> +	LIST_HEAD(sdt_notes);
>> +
>> +	ret = get_sdt_note_list(&sdt_notes, target);
>> +	if (!ret)
>> +		get_sdt_note_info(&sdt_notes, target);
>> +	else
>> +		sdt_err(ret, target);
>> +
>> +	cleanup_sdt_note_list(&sdt_notes);
>> +
>> +	return ret;
>> +}
>> +
>> +/*
>> + * print_sdt_notes() : wrapper function
>> + */
>> +void print_sdt_events(const char *arg)
>> +{
>> +	if (arg) {
>> +		filename__find_sdt(arg);
>> +		return;
>> +	}
>> +	pr_err("Error : File Name must be specified with \"sdt\" option!\n"
>> +	       "Usage :\n  perf list sdt <file-name>\n");
>> +
>> +	return;
>> +}
>>
>>
>

-- 
Thanks,
Hemant Kumar

