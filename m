Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbaDOFwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 01:52:32 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:60416 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbaDOFw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 01:52:26 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <alpine.DEB.2.01.1404150024030.11665@pmeerw.net>
References: <1397513467-21397-1-git-send-email-srinivas.pandruvada@linux.intel.com> <1397513467-21397-4-git-send-email-srinivas.pandruvada@linux.intel.com> <alpine.DEB.2.01.1404150024030.11665@pmeerw.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [Patch v5 3/6] IIO: core: Modify scan element type
From: Jonathan Cameron <jic23@kernel.org>
Date: Tue, 15 Apr 2014 06:52:23 +0100
To: Peter Meerwald <pmeerw@pmeerw.net>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <ce588f3f-c051-46ca-815e-08eebaf0ff8e@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On April 14, 2014 11:33:12 PM GMT+01:00, Peter Meerwald <pmeerw@pmeerw.net> wrote:
>> The current scan element type uses the following format:
>>   [be|le]:[s|u]bits/storagebits[>>shift].
>> To specify multiple elements in this type, added a repeat value.
>> So new format is:
>>   [be|le]:[s|u]bits/storagebits{X[repeat]}[>>shift].
>> Here X is specifying how may times, real/storage bits are repeating.
>> 
>> When X is value is 0 or 1, then repeat value is not used in the
>format,
>> and it will be same as existing format.
>
>minor comments inline
>
>> ---
>>  drivers/iio/industrialio-buffer.c | 41
>+++++++++++++++++++++++++++++++++------
>>  include/linux/iio/iio.h           |  9 +++++++++
>>  2 files changed, 44 insertions(+), 6 deletions(-)
>> 
>> diff --git a/drivers/iio/industrialio-buffer.c
>b/drivers/iio/industrialio-buffer.c
>> index e108f2a..aa90c68 100644
>> --- a/drivers/iio/industrialio-buffer.c
>> +++ b/drivers/iio/industrialio-buffer.c
>> @@ -150,7 +150,16 @@ static ssize_t iio_show_fixed_type(struct device
>*dev,
>>  		type = IIO_BE;
>>  #endif
>>  	}
>> -	return sprintf(buf, "%s:%c%d/%d>>%u\n",
>> +	if (this_attr->c->scan_type.repeat > 1)
>> +		return sprintf(buf, "%s:%c%d/%d{%d[repeat]}>>%u\n",
>> +		       iio_endian_prefix[type],
>> +		       this_attr->c->scan_type.sign,
>> +		       this_attr->c->scan_type.realbits,
>> +		       this_attr->c->scan_type.storagebits,
>> +		       this_attr->c->scan_type.repeat,
>> +		       this_attr->c->scan_type.shift);
>> +		else
>> +			return sprintf(buf, "%s:%c%d/%d>>%u\n",
>>  		       iio_endian_prefix[type],
>>  		       this_attr->c->scan_type.sign,
>>  		       this_attr->c->scan_type.realbits,
>> @@ -474,14 +483,22 @@ static int iio_compute_scan_bytes(struct
>iio_dev *indio_dev,
>>  	for_each_set_bit(i, mask,
>>  			 indio_dev->masklength) {
>>  		ch = iio_find_channel_from_si(indio_dev, i);
>> -		length = ch->scan_type.storagebits / 8;
>> +		if (ch->scan_type.repeat > 1)
>> +			length = ch->scan_type.storagebits / 8 *
>> +				ch->scan_type.repeat;
>
>so storagebits should be a multiple of 8 and != 0;
>we cannot have repeated groups of say 4 bits

Indeed not. Having unaligned data would probably prove more painful than using more
 memory... Real requirements will be stricter as power of 2 multiples of bytes only.
This is in theory the plan for all buffer elements..
>
>> +		else
>> +			length = ch->scan_type.storagebits / 8;
>>  		bytes = ALIGN(bytes, length);
>>  		bytes += length;
>>  	}
>>  	if (timestamp) {
>>  		ch = iio_find_channel_from_si(indio_dev,
>>  					      indio_dev->scan_index_timestamp);
>> -		length = ch->scan_type.storagebits / 8;
>> +		if (ch->scan_type.repeat > 1)
>> +			length = ch->scan_type.storagebits / 8 *
>> +				ch->scan_type.repeat;
>> +		else
>> +			length = ch->scan_type.storagebits / 8;
>>  		bytes = ALIGN(bytes, length);
>>  		bytes += length;
>>  	}
>> @@ -957,7 +974,11 @@ static int iio_buffer_update_demux(struct
>iio_dev *indio_dev,
>>  					       indio_dev->masklength,
>>  					       in_ind + 1);
>>  			ch = iio_find_channel_from_si(indio_dev, in_ind);
>> -			length = ch->scan_type.storagebits/8;
>> +			if (ch->scan_type.repeat > 1)
>> +				length = ch->scan_type.storagebits / 8 *
>> +					ch->scan_type.repeat;
>> +			else
>> +				length = ch->scan_type.storagebits / 8;
>>  			/* Make sure we are aligned */
>>  			in_loc += length;
>>  			if (in_loc % length)
>> @@ -969,7 +990,11 @@ static int iio_buffer_update_demux(struct
>iio_dev *indio_dev,
>>  			goto error_clear_mux_table;
>>  		}
>>  		ch = iio_find_channel_from_si(indio_dev, in_ind);
>> -		length = ch->scan_type.storagebits/8;
>> +		if (ch->scan_type.repeat > 1)
>> +			length = ch->scan_type.storagebits / 8 *
>> +				ch->scan_type.repeat;
>> +		else
>> +			length = ch->scan_type.storagebits / 8;
>>  		if (out_loc % length)
>>  			out_loc += length - out_loc % length;
>>  		if (in_loc % length)
>> @@ -990,7 +1015,11 @@ static int iio_buffer_update_demux(struct
>iio_dev *indio_dev,
>>  		}
>>  		ch = iio_find_channel_from_si(indio_dev,
>>  			indio_dev->scan_index_timestamp);
>> -		length = ch->scan_type.storagebits/8;
>> +		if (ch->scan_type.repeat > 1)
>> +			length = ch->scan_type.storagebits / 8 *
>> +				ch->scan_type.repeat;
>> +		else
>> +			length = ch->scan_type.storagebits / 8;
>>  		if (out_loc % length)
>>  			out_loc += length - out_loc % length;
>>  		if (in_loc % length)
>> diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
>> index 5629c92..324ae00 100644
>> --- a/include/linux/iio/iio.h
>> +++ b/include/linux/iio/iio.h
>> @@ -177,6 +177,14 @@ struct iio_event_spec {
>>   *			shift:		Shift right by this before masking out
>>   *					realbits.
>>   *			endianness:	little or big endian
>> + *			repeat:		No. of times real/storage bits repeats.
>
>I'd rather spell out 'Number'
>
>> + *					By default, when repeat is set to 0
>> + *					repeat value is treated as 1. When
>> + *					repeat value is 0 or 1, then there is
>> + *					no change in existing scan element
>
>'no change in existing scan element' -- this makes sense only now
>
>maybe: 'When the repeat element is more than 1, then the type element
>in 
>sysfs will show a repeat value. Otherwise, the number of repetitions is
>omitted.'
>
>> + *					type, in sysfs. When set to more than
>
>no comma before 'in sysfs.'
>
>
>> + *					1, then the type element in sysfs will
>> + *					show repeat value.
>>   * @info_mask_separate: What information is to be exported that is
>specific to
>>   *			this channel.
>>   * @info_mask_shared_by_type: What information is to be exported
>that is shared
>> @@ -219,6 +227,7 @@ struct iio_chan_spec {
>>  		u8	realbits;
>>  		u8	storagebits;
>>  		u8	shift;
>> +		u8	repeat;
>>  		enum iio_endian endianness;
>>  	} scan_type;
>>  	long			info_mask_separate;
>> 

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
